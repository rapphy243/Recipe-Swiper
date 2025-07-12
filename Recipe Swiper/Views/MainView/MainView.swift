//
//  MainView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftUI

// Implemented MVVM?
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
    @StateObject var model = MainViewModel()
    @EnvironmentObject var appData: AppData // Where the recipe is stored
    var body: some View {
        NavigationStack {
            ZStack {
                ProgressView()
                    .opacity(appData.isLoading ? 1 : 0)
                    .transition(.opacity)
                SwipableRecipeCard(
                    recipe: $appData.recipe,
                    onSwipeLeft: { Task { await saveRecipe() } },
                    onSwipeRight: { Task { await appData.fetchNewRecipe() } }
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
        let savedRecipe = RecipeModel(from: appData.recipe)
        print("Saved: \(savedRecipe.title)")
        await appData.fetchNewRecipe()
    }
}

#Preview {
    MainView()
        .environmentObject(AppData())
}
