//
//  ContentView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    @Published var selection: Int
    @Published var mainViewModel: MainViewModel
    
    init() {
        self.selection = 1
        self.mainViewModel = MainViewModel()
    }
}

struct ContentView: View {
    @ObservedObject var model = ContentViewModel()
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        TabView(selection: $model.selection) {
            Tab("Groceries", systemImage: "checklist", value: 0) {
                GroceryView()
            }
            Tab("Home", systemImage: "house", value: 1) {
                MainView()
                    .environmentObject(model.mainViewModel)
            }
            Tab("Cookbook", systemImage: "book.closed", value: 2, role: .search) {
                SavedRecipesView()
                    .environmentObject(model.mainViewModel)
            }
        }
        // There is a problem with the accessory pushing mainView up, so not enabled for now.
        // Might fall back to original implementation...
        //            .tabViewBottomAccessory {
        //                if selection == 1 {
        //                    // Random quotes
        //
        //                }
        //            }
        .fullScreenCover(isPresented: $isOnboarding) {
            OnboardingView()
                .environmentObject(model.mainViewModel)
                .presentationBackground(colorScheme == .dark ? .ultraThickMaterial : .ultraThinMaterial)
        }

    }
}

#Preview {
    let previewUserDefaults = UserDefaults(suiteName: "Preview")!
    previewUserDefaults.set(false, forKey: "isOnboarding")
    return ContentView()
        .defaultAppStorage(previewUserDefaults)
}

#Preview {
    let previewUserDefaults = UserDefaults(suiteName: "Preview")!
    previewUserDefaults.set(true, forKey: "isOnboarding")
    return ContentView()
        .defaultAppStorage(previewUserDefaults)
}
