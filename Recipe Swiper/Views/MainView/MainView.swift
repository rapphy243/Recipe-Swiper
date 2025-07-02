//
//  MainView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

// TODO: Implement MVVM, to also pass variables to toolbar

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var isOnboarding: Bool?
    @Published var showFilters: Bool
    @Published var recipe: Recipe

    init() {
        self.isOnboarding = UserDefaults.standard.bool(forKey: "isOnboarding")
        self.showFilters = false
        guard let recipe = UserDefaults.standard.data(forKey: "recipe") else {
            recipe = Recipe.empty
            return
        }
        self.recipe = try! JSONDecoder().decode(Recipe.self, from: recipe)
    }

    init(recipe: Recipe) {
        self.isOnboarding = UserDefaults.standard.bool(forKey: "isOnboarding")
        self.showFilters = false
        self.recipe = recipe
    }
}

struct MainView: View {
    @StateObject var model = MainViewModel()
    var body: some View {
        NavigationStack {
            SwipableRecipeCard(recipe: model.recipe)
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
    }
}

#Preview {
    MainView()
}
