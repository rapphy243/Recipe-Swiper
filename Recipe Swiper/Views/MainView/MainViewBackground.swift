//
//  MainViewBackground.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 8/4/25.
//

import SwiftUI

// https://www.reddit.com/r/iOSProgramming/comments/1ejoppj/cool_swiftui_gradient_that_users_love

struct MainViewBackground: View {
    @ObservedObject private var settings = AppSettings.shared
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(
                    colors: colorScheme == .dark
                        ? [
                            settings.backgroundDarkColor1,  // Approximate color for the top
                            settings.backgroundDarkColor2,  // Approximate color for the bottom
                        ]
                        : [
                            settings.backgroundColor1,  // Approximate color for the top
                            settings.backgroundColor2,  // Approximate color for the bottom
                        ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.1),  // Transparent white
                    Color.clear,  // Fully transparent
                ]),
                center: .bottomLeading,
                startRadius: 5,
                endRadius: 400
            )
            .blendMode(.overlay)
            .edgesIgnoringSafeArea(.all)
        }

    }
}

#Preview {
    MainViewBackground()
}
