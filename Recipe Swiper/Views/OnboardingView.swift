//
//  OnboardingView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//
// Implementation slightly refrenced from https://medium.com/@sharma17krups/onboarding-view-with-swiftui-b26096049be3

import SwiftUI

struct OnboardingView: View {
    @State private var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab) {
            OnboardingAboutView()
                .tag(0)
            OnboardingHowToView(selectedTab: $selectedTab)
                .tag(1)
            OnboardingGetStartedView()
                .tag(2)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .animation(.easeOut(duration: 0.2), value: selectedTab) // https://stackoverflow.com/questions/61827496/swiftui-how-to-animate-a-tabview-selection
    }
}

#Preview {
    OnboardingView()
}
