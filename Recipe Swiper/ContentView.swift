//
//  ContentView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 1
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    var body: some View {
        TabView(selection: $selection) {
            Tab("Groceries", systemImage: "checklist", value: 0) {
                GroceryView()
            }
            Tab("Home", systemImage: "house", value: 1) {
                MainView()
            }
            Tab("Cookbook", systemImage: "book.closed", value: 2) {
                SavedRecipesView()
            }
            Tab(
                "Search",
                systemImage: "magnifyingglass",
                value: 3,
                role: .search
            ) {
                // Likely used for cookbook searching
            }
        }
        // There is a problem with the accessory pushing mainView up, so not enabled for now.
        // Might fall back to original implementation...
//        .tabViewBottomAccessory {
//            if selection == 1 {
//                // Random quotes
//            
//            }
//        }
        .fullScreenCover(isPresented: $isOnboarding) {
            OnboardingView()
        }

    }
}

#Preview {
    let previewUserDefaults = UserDefaults(suiteName: "Preview")!
    previewUserDefaults.set(false, forKey: "isOnboarding")

    return ContentView()
        .defaultAppStorage(previewUserDefaults)
}
