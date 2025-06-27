//
//  MainView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

// TODO: Implement MVVM, to also pass variables to toolbar

import SwiftUI

struct MainView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var showFilters: Bool = false

    var body: some View {
        NavigationStack {
            RecipeCard()
            Spacer()
                .navigationTitle("Home")
                .toolbar {
                    MainToolBar()
                }
        }
        .sheet(isPresented: $showFilters) {
            FiltersView()
        }
    }
}

#Preview {
    MainView()
}
