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
    @Published var searchText: String

    init() {
        self.selection = 1
        self.searchText = ""
    }
}

struct ContentView: View {
    @StateObject var model = ContentViewModel()
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        TabView(selection: $model.selection) {
            //            Tab("Groceries", systemImage: "checklist", value: 0) {
            //                GroceryView()
            //            }
            Tab("Home", systemImage: "house", value: 1) {
                MainView()
            }
            Tab("Cookbook", systemImage: "book.closed", value: 2, role: .search)
            {
                SavedRecipesView(SearchText: $model.searchText)
                    .searchable(text: $model.searchText)
            }
        }
        .fullScreenCover(isPresented: $isOnboarding) {
            OnboardingView()
                .presentationBackground(
                    colorScheme == .dark
                        ? .ultraThickMaterial : .ultraThinMaterial
                )
        }

    }
}

#Preview {
    let previewUserDefaults = UserDefaults(suiteName: "Preview")!
    previewUserDefaults.set(false, forKey: "isOnboarding")
    return ContentView()
        .defaultAppStorage(previewUserDefaults)
        .environmentObject(AppData())
}

#Preview {
    let previewUserDefaults = UserDefaults(suiteName: "Preview")!
    previewUserDefaults.set(true, forKey: "isOnboarding")
    return ContentView()
        .defaultAppStorage(previewUserDefaults)
        .environmentObject(AppData())
}
