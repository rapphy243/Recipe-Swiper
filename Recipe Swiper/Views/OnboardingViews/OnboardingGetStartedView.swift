//
//  OnboardingHowGetStartedView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano & Zane Matarieh on 4/11/25.
//
//  Partially edited by Claude 2.5

import SwiftUI

// Random color generator for confetti

// Confetti animation modifier

struct OnboardingGetStartedView: View {
    @EnvironmentObject var model: OnboardingViewModel
    @EnvironmentObject var appData: AppData
    @State private var isAnimating = false
    @State private var isButtonPressed = false
    @State private var showConfetti = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 30) {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.green)
                    .symbolEffect(.bounce, value: showConfetti)

                VStack(spacing: 15) {
                    Text("You're All Set!")
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
                        "Ready to discover your next favorite meal? Tap the button below to start swiping through delicious recipes!"
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

                Button {
                    withAnimation(.spring()) {
                        isButtonPressed = true
                        showConfetti = true
                    }
                    Task {
                        await appData.fetchNewRecipe()
                    }
                    // Add slight delay before dismissing onboarding
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        UserDefaults.standard.set(false, forKey: "isOnboarding")
                    }
                } label: {
                    Text("Let's Get Cooking!")
                        .frame(maxWidth: .infinity)
                        .scaleEffect(isButtonPressed ? 0.95 : 1.0)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)
                .padding(.bottom, 50)
                .disabled(isButtonPressed)
            }
            .padding(.top)

            // Confetti effect when button is pressed
            if showConfetti {
                ForEach(0..<40) { _ in
                    Circle()
                        .fill(Color.random)
                        .frame(width: 10, height: 10)
                        .modifier(ConfettiModifier())
                }
            }
        }
        .onAppear {
            isAnimating = true
            showConfetti = false
            isButtonPressed = false
        }
    }
}
extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
struct ConfettiModifier: ViewModifier {
    @State private var isAnimating = false

    func body(content: Content) -> some View {
        content
            .offset(
                x: isAnimating ? .random(in: -150...150) : 0,
                y: isAnimating ? .random(in: -400...0) : 0
            )
            .opacity(isAnimating ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: 1.0)) {
                    isAnimating = true
                }
            }
    }
}
#Preview {
    OnboardingGetStartedView()
        .environmentObject(OnboardingViewModel())
        .environmentObject(AppData())
}
