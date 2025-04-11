//
//  ContentView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

// https://www.hackingwithswift.com/quick-start/swiftui/adding-tabview-and-tabitem
// https://stackoverflow.com/questions/57802440/how-to-set-a-default-tab-in-swiftuis-tabview
// https://www.swiftyplace.com/blog/tabview-in-swiftui-styling-navigation-and-more

import SwiftUI
struct ContentView: View {
    @State private var selction = 1 // Show MainView
    @AppStorage("isOnboarding") var isOnboarding: Bool = true // if "isOnboarding" doesn't exist, sets it to true
    var body: some View {
        if isOnboarding { // Show OnboardingView on first start
            OnboardingView()
        }
        else {
            TabView(selection: $selction) {
                Group {
                    FindRecipesView() // View to go to
                        .tabItem {
                            Label("Find Recipes", systemImage: "sparkles") // Icon & Label on tab
                        }
                        .tag(0)
                    MainView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(1)
                    SavedRecipesView()
                        .tabItem {
                            Label("Saved Recipes", systemImage: "fork.knife")
                        }
                        .tag(3)
                }
                .toolbarBackground(.indigo, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                .toolbarColorScheme(.dark, for: .tabBar)
            }
        }
    }
}

#Preview {
    @Previewable @AppStorage("isOnboarding") var isOnboarding = false // To ignore onboarding in preview window
    ContentView()
}
