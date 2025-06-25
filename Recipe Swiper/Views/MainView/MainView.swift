//
//  MainView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftUI

struct MainView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    var body: some View {
        NavigationStack {
            VStack {
                Card {
                    Text("Hello World")
                        .onAppear {
                            UserDefaults.standard.set(
                                false,
                                forKey: "isOnboarding"
                            )
                        }
                }
            }
            .toolbar {
                MainToolBar()
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    MainView()
}
