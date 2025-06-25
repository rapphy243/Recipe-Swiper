//
//  MainToolBar.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/23/25.
//

import SwiftUI

struct MainToolBar: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {

            } label: {
                Image(
                    systemName: "line.3.horizontal.decrease.circle"
                )
            }
            Menu {
                Button("Refresh Recipe", systemImage: "arrow.clockwise")
                {

                }
                Button("Settings", systemImage: "gear") {

                }
                NavigationLink(destination: EmptyView()) {
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
}
