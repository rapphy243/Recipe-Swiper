//
//  OnboardingView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//
// Implementation slightly refrenced from https://medium.com/@sharma17krups/onboarding-view-with-swiftui-b26096049be3

import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var currentTab: Int
    @Published var showFinalTab: Bool
    @Published var recipe: Recipe
    
    init() {
        self.currentTab = 0
        self.showFinalTab = false
        self.recipe = Recipe.Cake
    }
    
    init(recipe: Recipe) {
        self.currentTab = 0
        self.showFinalTab = false
        self.recipe = recipe
    }
}

struct OnboardingView: View {
    @StateObject var model = OnboardingViewModel()
    var body: some View {
        NavigationStack {
            TabView(selection: $model.currentTab) {
                OnboardingAboutView()
                    .tag(0)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .environmentObject(model)
        }
    }
}

#Preview {
    OnboardingView()
}
