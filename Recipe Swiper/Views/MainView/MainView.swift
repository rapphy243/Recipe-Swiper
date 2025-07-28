//
//  MainView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftData
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var showFilters: Bool
    @Published var showSettings: Bool
    @Published var isOnboarding: Bool

    init() {
        self.showFilters = false
        self.showSettings = false
        self.isOnboarding = UserDefaults.standard.bool(forKey: "isOnboarding")
    }
}

struct MainView: View {
    @Environment(\.modelContext) var modelContext
    @StateObject var model = MainViewModel()
    @EnvironmentObject var appData: AppData  // Where the shown recipe is stored
    var body: some View {
        NavigationStack {
            ZStack {
                ProgressView()
                    .opacity(appData.isLoading ? 1 : 0)
                    .transition(.opacity)
                SwipableRecipeCard(
                    recipe: appData.recipe,
                    onSwipeLeft: { Task { await appData.fetchNewRecipe() } },
                    onSwipeRight: { Task { await  saveRecipe() } }
                )
                .offset(y: -50)
                .opacity(appData.isLoading ? 0 : 1)
                .transition(.opacity)
            }
            .animation(.easeInOut, value: appData.isLoading)
            .navigationTitle("Snack Swipe")
            .navigationBarTitleDisplayMode(.large)
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

    private func saveRecipe() async {
        // Check if the recipe already exists in the model container
        let recipeID = appData.recipe.id
        let fetchDescriptor = FetchDescriptor<RecipeModel>(
            predicate: #Predicate {
                $0.id == recipeID
            }
        )
        let existingRecipes: [RecipeModel] = try! modelContext.fetch(fetchDescriptor)
        guard existingRecipes.isEmpty else {
            print("Recipe already exists in container, skipping save.")
            Task {
                await appData.fetchNewRecipe()
            }
            return  // Exit if the recipe exists
        }
        
        let savedRecipe = RecipeModel(from: appData.recipe)
        modelContext.insert(savedRecipe)

        print("Saved: \(savedRecipe.title)")
        await appData.fetchNewRecipe()
    }
}

#Preview {
    MainView()
        .environmentObject(AppData())
}
