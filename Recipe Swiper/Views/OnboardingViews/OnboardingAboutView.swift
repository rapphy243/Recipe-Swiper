//
//  OnboardingAboutView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 7/5/25.
//

import SwiftUI

struct OnboardingAboutView: View {
    @EnvironmentObject var model: OnboardingViewModel
    @State private var isAnimating = false

    private let features:
        [(systemName: String, title: String, color: Color, delay: Double)] = [
            ("hand.tap", "Simple", .blue, 1.0),
            ("magnifyingglass", "Discover", .purple, 1.4),
            ("bookmark.fill", "Save", .green, 1.8),
        ]

    var body: some View {

        VStack(spacing: 30) {
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .symbolEffect(.bounce, value: isAnimating)
                .foregroundColor(.orange)
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
                ForEach(Array(features.enumerated()), id: \.offset) {
                    index,
                    feature in
                    FeatureItem(
                        systemName: feature.systemName,
                        title: feature.title,
                        color: feature.color,
                        delay: feature.delay
                    )
                    .scaleEffect(isAnimating ? 1 : 0.8)
                    .opacity(isAnimating ? 1 : 0)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8).delay(
                            1.0 + Double(index) * 0.2
                        ),
                        value: isAnimating
                    )
                }
            }
            .offset(y: isAnimating ? 0 : 20)

            Button {
                withAnimation {
                    model.currentTab = 1
                }
            } label: {
                HStack {
                    Text("Next")
                    Image(systemName: "arrow.right")
                }
            }
            .buttonStyle(.borderedProminent)
            .clipShape(.rect(cornerRadius: 16))
            .sensoryFeedback(.impact, trigger: model.currentTab)
            .padding(.bottom)
        }
        .padding(.top)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    OnboardingAboutView()
        .environmentObject(OnboardingViewModel())

}
