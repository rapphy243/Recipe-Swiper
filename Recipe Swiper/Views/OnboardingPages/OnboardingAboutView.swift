//
//  OnboardingAboutView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//
// Partially generated with Gemini 2.5 Pro. Prompt: "I am creating a SwiftUI app onboarding page about what the app is. The app is basically tinder except with recipes."

import SwiftUI

struct OnboardingAboutView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            // This will parobably be replaced with the app icon
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.orange)
            //
            VStack(spacing: 15) {
                Text("Discover Your Next Meal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Swipe right on recipes you love, swipe left on those you don't. It's the easiest way to build your personal cookbook!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.top)
    }
}

#Preview {
    OnboardingAboutView()
}
