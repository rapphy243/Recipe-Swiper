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
        Text( /*@START_MENU_TOKEN@*/"Hello, World!" /*@END_MENU_TOKEN@*/)
            .onAppear {
                UserDefaults.standard.set(false, forKey: "isOnboarding")
            }
    }
}

#Preview {
    MainView()
}
