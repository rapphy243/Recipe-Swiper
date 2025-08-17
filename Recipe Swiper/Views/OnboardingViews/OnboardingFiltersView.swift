//
//  OnboardingFiltersView.swift
//  Recipe Swiper
//
//  Created by Zane Matarieh on 4/29/25.
//

// TODO: Actually let users input some filters.

import SwiftUI

struct OnboardingFiltersView: View {
    @Environment(OnboardingViewModel.self) var model
    @State private var isAnimating = false

    private let features:
        [(systemName: String, title: String, color: Color, delay: Double)] = [
            ("leaf", "Diets", .green, 1.0),
            ("fork.knife", "Meal Types", .orange, 1.4),
            ("exclamationmark.triangle", "Intolerances", .red, 1.8),
            ("globe", "Cuisines", .blue, 2.2),
        ]

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "line.3.horizontal.decrease.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.blue)

            VStack(spacing: 15) {
                Text("Customize Your Filters")
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
                    "Choose your dietary needs, favorite cuisines, and more to personalize your recipe experience."
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
            .padding(.horizontal)
            .offset(y: isAnimating ? 0 : 20)

            Button {
                withAnimation {
                    model.currentTab = 3
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
    OnboardingFiltersView()
        .environment(OnboardingViewModel())
}
