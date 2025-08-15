//
//  Recipe_SwiperApp.swift
//  Recipe Swiper
//
//  Created by Snack Swipe Team (Zane, Tyler, Rapphy) on 4/11/25.
//

import SwiftData
import SwiftUI

@MainActor
class AppData: ObservableObject {
    @Published var recipe: Recipe
    @Published var isLoading: Bool
    @Published var recipeError: Error?

    init(recipe: Recipe) {
        self.recipe = recipe
        self.isLoading = false
    }
    init() {
        if let recipeData = UserDefaults.standard.data(forKey: "recipe"),
            let decodedRecipe = try? JSONDecoder().decode(
                Recipe.self,
                from: recipeData
            )
        {
            self.recipe = decodedRecipe
        } else {
            self.recipe = Recipe.empty
        }
        self.isLoading = false
    }

    func fetchNewRecipe() async {
        isLoading = true
        recipeError = nil
        do {
            let fetched = try await fetchRandomRecipe()
            self.recipe = fetched
            UserDefaults.standard.set(
                try? JSONEncoder().encode(fetched),
                forKey: "recipe"
            )
            isLoading = false
            try? await self.recipe.generateSummary()
        } catch {
            isLoading = false
            recipeError = error
        }
    }
}

@main
struct Recipe_SwiperApp: App {
    @StateObject private var appData = AppData()  // We need the Recipe
    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([  // What objects that are going to be in the container
            RecipeModel.self,
            AnalyzedInstructionModel.self,
            InstructionStepModel.self,
            InstructionComponentModel.self,
            InstructionLengthModel.self,
            MeasuresModel.self,
            MeasurementUnitModel.self,
        ])
        let modelConfiguration = ModelConfiguration(  // Configuration for the model container
            schema: schema,  // the objects above
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(  // Inialize the container for the data we are storing
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(appData)
    }
}
