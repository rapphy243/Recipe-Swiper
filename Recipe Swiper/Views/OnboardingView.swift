//
//  OnboardingView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//
// Implementation slightly refrenced from https://medium.com/@sharma17krups/onboarding-view-with-swiftui-b26096049be3

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        TabView {
            OnboardingAboutView()
            OnboardingHowToView()
            OnboardingGetStartedView()
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

#Preview {
    OnboardingView()
}
