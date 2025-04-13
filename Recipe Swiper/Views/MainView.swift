//
//  MainView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI

struct MainView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, World!")
                .padding()
                Text("This is the Main Screen")
                    .navigationTitle("Home")
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu(content: {
                            Button("Restart Onboarding", systemImage: "gear") {
                                isOnboarding = true
                            }
                        },
                        label: {
                            Image(systemName: "ellipsis")
                        })
                }
            }
        }
    }
}

#Preview {
    MainView()
}
