//
//  ContentView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

// https://www.hackingwithswift.com/quick-start/swiftui/adding-tabview-and-tabitem

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MainView() // View to go to
                .tabItem {
                    Label("Home", systemImage: "house") // Icon on tab
            }
        }
    }
}

#Preview {
    ContentView()
}
