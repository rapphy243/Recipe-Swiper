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
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .padding()
            Text("This is the Main Screen")
                .navigationTitle("Home")
            Button(action: {
                isOnboarding = true
            }) {
                Text("Start On Boarding")
            }
        }
    }
}

#Preview {
    MainView()
}
