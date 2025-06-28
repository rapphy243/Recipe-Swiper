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
            SwipableRecipeCard()
                .offset(y: -50) 
                .navigationBarTitle("Snack Swipe", displayMode: .inline) // Scroll View in Recipe card messes up the title, so this is fix. :/
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
