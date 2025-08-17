//
//  MainToolBar.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/23/25.
//

import SwiftUI

struct MainToolBar: ToolbarContent {
    @Environment(MainViewModel.self) var model
    @EnvironmentObject var appData: AppData
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .primaryAction) {
            Button {
                model.showFilters = true
            } label: {
                Image(
                    systemName: "line.3.horizontal.decrease.circle"
                )
            }
        }
        ToolbarItemGroup(placement: .confirmationAction) {
            Menu {
                Button("Refresh Recipe", systemImage: "arrow.clockwise") {
                    Task {
                        await appData.fetchNewRecipe()
                    }
                }
                Button("Settings", systemImage: "gear") {
                    model.showSettings = true
                }
                NavigationLink(destination: AboutView()) {
                    Label("About", systemImage: "info.circle")
                }
            } label: {
                Image(systemName: "ellipsis")
            }
        }
    }
}

#Preview {
    MainView()
        .environment(MainViewModel())
        .environmentObject(AppData())
}
