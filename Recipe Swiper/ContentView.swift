//
//  ContentView.swift
//  Recipe Swiper
//
//  Created by Snack Swipe Team (Zane, Tyler, Rapphy) on 4/11/25.
//

import SwiftUI

@MainActor
@Observable class ContentViewModel {
    var selection: Int
    var searchText: String

    init() {
        self.selection = 1
        self.searchText = ""
    }
}

struct ContentView: View {
    @State var model = ContentViewModel()
    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        TabView(selection: $model.selection) {
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
