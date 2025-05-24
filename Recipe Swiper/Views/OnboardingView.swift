//
//  OnboardingView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//
// Implementation slightly refrenced from https://medium.com/@sharma17krups/onboarding-view-with-swiftui-b26096049be3

import SwiftUI

struct OnboardingView: View {
    @State private var selectedTab: Int = 0
    @State private var recipe = loadCakeRecipe()
    @State private var showFinalTab: Bool = false
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                OnboardingAboutView(selectedTab: $selectedTab)
                    .tag(0)
                OnboardingFiltersView(selectedTab: $selectedTab, recipe: $recipe)
                    .tag(1)
                OnboardingHowToView(recipe: $recipe, selectedTab: $selectedTab)
                    .tag(2)
                OnboardingInputAPIView(selectedTab: $selectedTab, showFinalTab: $showFinalTab)
                    .tag(3)
                if showFinalTab {
                    OnboardingGetStartedView()
                        .tag(4)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Remove tabbview dots
            .animation(.easeOut(duration: 0.2), value: selectedTab)  // https://stackoverflow.com/questions/61827496/swiftui-how-to-animate-a-tabview-selection
        }
    }
}

#Preview {
    OnboardingView()
}
