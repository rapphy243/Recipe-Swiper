//
//  OnboardingHowGetStartedView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano & Zane on 4/11/25.
//
//  Partially edited by Claude 2.5

import SwiftUI

struct OnboardingGetStartedView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @State private var isButtonPressed = false
    @State private var showConfetti = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 30) {
                Spacer()
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
                    
                    Text("Ready to discover your next favorite meal? Tap the button below to start swiping through delicious recipes!")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding(.top)
            
            Button {
                withAnimation(.spring()) {
                    isButtonPressed = true
                    showConfetti = true
                }
                
                // Add slight delay before dismissing onboarding
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    isOnboarding = false
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
            
            // Confetti effect when button is pressed
            if showConfetti {
                ForEach(0..<20) { _ in
                    Circle()
                        .fill(Color.random)
                        .frame(width: 10, height: 10)
                        .modifier(ConfettiModifier())
                }
            }
        }
        .onAppear {
            showConfetti = false
            isButtonPressed = false
        }
    }
}

// Random color generator for confetti
extension Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

// Confetti animation modifier
struct ConfettiModifier: ViewModifier {
    @State private var isAnimating = false
    
    func body(content: Content) -> some View {
        content
            .offset(x: isAnimating ? .random(in: -150...150) : 0,
                   y: isAnimating ? .random(in: -400...0) : 0)
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
}
