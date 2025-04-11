//
//  OnboardingView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//
// Implementation slightly refrenced from https://medium.com/@sharma17krups/onboarding-view-with-swiftui-b26096049be3
import SwiftUI

struct OnboardingView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    var body: some View {
        Text("This is the onboarding screen")
        Button(action: {
            isOnboarding = false
        }) {
            Text("End On Boarding")
        }
    }
}

#Preview {
    OnboardingView()
}
