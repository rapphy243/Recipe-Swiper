//
//  MainView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftUI

// Implemented MVVM?
@MainActor
class MainViewModel: ObservableObject {
    @Published var showFilters: Bool
    @Published var showSettings: Bool
    @Published var recipe: Recipe
    @Published var isOnboarding: Bool

    init() {
        self.showFilters = false
        self.showSettings = false
        self.isOnboarding = UserDefaults.standard.bool(forKey: "isOnboarding")
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
    }

    init(recipe: Recipe) {
        self.showFilters = false
        self.showSettings = false
        self.recipe = recipe
        self.isOnboarding = UserDefaults.standard.bool(forKey: "isOnboarding")
    }

    func saveRecipe() async {
        let savedRecipe = RecipeModel(from: self.recipe)
        print("Saved: \(savedRecipe.title)")
        await fetchNewRecipe()

    }

    func discardRecipe() async {
        print("Discarded: \(self.recipe.title)")
        await fetchNewRecipe()
    }

    func fetchNewRecipe() async {
        Task {
            self.recipe = try await fetchRandomRecipe()
        }
    }
}

struct MainView: View {
    @EnvironmentObject var model: MainViewModel
    var body: some View {
        NavigationStack {
            SwipableRecipeCard(
                recipe: $model.recipe,
                onSwipeLeft: { Task { await model.discardRecipe() } },
                onSwipeRight: { Task { await model.saveRecipe() } }
            )
            .offset(y: -50)
            .navigationBarTitle("Snack Swipe", displayMode: .inline)  // Scroll View in Recipe card messes up the title, so this is fix. :/
            .toolbar {
                MainToolBar()
            }
        }
        .environmentObject(model)
        .sheet(isPresented: $model.showFilters) {
            FiltersView()
        }
        .sheet(isPresented: $model.showSettings) {
            SettingsView()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(MainViewModel())
}
