//
//  ContentView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

// https://www.hackingwithswift.com/quick-start/swiftui/adding-tabview-and-tabitem
// https://stackoverflow.com/questions/57802440/how-to-set-a-default-tab-in-swiftuis-tabview
// https://www.swiftyplace.com/blog/tabview-in-swiftui-styling-navigation-and-more
// https://stackoverflow.com/a/76287539

import SwiftUI

struct ContentView: View {
    @State private var savedRecipes: [Recipe] = []
    @State private var discardedRecipes: [Recipe] = []
    @State private var selection = 1  // Show MainView
    @AppStorage("isOnboarding") var isOnboarding: Bool = true  // if "isOnboarding" doesn't exist, sets it to true
    var body: some View {
            TabView(selection: $selection) {
                Group {
                    DiscardedRecipesView(discardedRecipes: $discardedRecipes)  // View to go to
                        .tabItem {
                            Label("Discarded Recipes", systemImage: "trash")  // Icon & Label on tab
                        }
                        .tag(0)
                    MainView(savedRecipes: $savedRecipes, discardedRecipes: $discardedRecipes)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(1)
                    SavedRecipesView(savedRecipes: savedRecipes)
                        .tabItem {
                            Label("Saved Recipes", systemImage: "fork.knife")
                        }
                        .tag(3)
                }
                // Temp Colors
                .toolbarBackground(.indigo, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            }
            .fullScreenCover(isPresented: $isOnboarding) {
                OnboardingView()
            }
    }
}

#Preview {
    @Previewable @AppStorage("isOnboarding") var isOnboarding = false  // To ignore onboarding in preview window
    ContentView()
}
