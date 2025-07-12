//
//  Recipe_SwiperApp.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
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
        Task {
            isLoading = true
            self.recipe = try await fetchRandomRecipe()
            UserDefaults.standard.set(
                try? JSONEncoder().encode(self.recipe),
                forKey: "recipe"
            )
            isLoading = false
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
