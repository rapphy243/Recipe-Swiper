//
//  OnboardingAboutView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//
// Partially generated with Gemini 2.5 Pro. Prompt: "I am creating a SwiftUI app onboarding page about what the app is. The app is basically tinder except with recipes." & Minor edits with Claude 2.5 (Animation part)

import SwiftUI

struct OnboardingAboutView: View {
    @State private var isAnimating = false

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
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.5).delay(0.2),
                        value: isAnimating
                    )

                Text(
                    "Swipe right on recipes you love, swipe left on those you don't. It's the easiest way to build your personal cookbook!"
                )
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
                .animation(
                    .easeOut(duration: 0.5).delay(0.4),
                    value: isAnimating
                )
            }
            .padding(.horizontal)

            HStack(spacing: 40) {
                FeatureItem(
                    systemName: "hand.tap",
                    title: "Simple",
                    color: .blue,
                    delay: 0.6
                )

                FeatureItem(
                    systemName: "magnifyingglass",
                    title: "Discover",
                    color: .purple,
                    delay: 1.0
                )

                FeatureItem(
                    systemName: "bookmark.fill",
                    title: "Save",
                    color: .green,
                    delay: 0.8
                )

            }
            .opacity(isAnimating ? 1 : 0)
            .offset(y: isAnimating ? 0 : 20)

            Spacer()
        }
        .padding(.top)
        .onAppear {
            isAnimating = true
        }
    }
}

struct FeatureItem: View {
    let systemName: String
    let title: String
    let color: Color
    let delay: Double
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Image(systemName: systemName)
                .font(.system(size: 30))
                .foregroundColor(color)
                .symbolEffect(.bounce, value: isAnimating)

            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(.secondary)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    OnboardingAboutView()
}
