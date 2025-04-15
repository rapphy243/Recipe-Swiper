//
//  OnboardingHowToView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI

struct OnboardingHowToView: View {
    @State private var recipe: Recipe = loadCakeRecipe()
    @State private var offset: CGSize = .zero
    @State private var step = 0
    @State private var isAnimatingReset = false // To disable gesture during reset

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(instructionText)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
                .id(step) // Add ID to force text update animation if desired

            // Use the non-optional recipe directly
            SmallRecipeCardView(recipe: recipe) {
                // Only allow tapping in the first step
                if step == 0, let urlString = recipe.sourceUrl, let url = URL(
                    string: urlString
                ) {
                    UIApplication.shared.open(url)
                    // Move to next step immediately after tap action is initiated
                    step += 1
                }
            }
            .offset(offset)
            .rotationEffect(.degrees(Double(offset.width / 20)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        // Prevent dragging while the card is resetting
                        guard !isAnimatingReset else { return }

                        // Only allow dragging in the relevant steps
                        if step == 2 || step == 3 {
                            offset = gesture.translation
                        }
                    }
                    .onEnded { gesture in
                        // Prevent new actions while the card is resetting
                        guard !isAnimatingReset else { return }

                        let screenWidth = UIScreen.main.bounds.width
                        let swipeThreshold: CGFloat = 50 // Min distance for a swipe

                        if step == 2 && offset.width < -swipeThreshold {
                            // Swipe Left Success
                            isAnimatingReset = true // Disable gesture
                            withAnimation(.spring()) {
                                // Animate far off-screen left
                                offset = CGSize(width: -screenWidth, height: 0)
                            }
                            // Schedule reset after 1 second
                            DispatchQueue.main
                                .asyncAfter(deadline: .now() + 1.0) {
                                    step += 1 // Move to next instruction
                                    // Reset offset (will animate back due to .animation modifier)
                                    offset = .zero
                                    isAnimatingReset = false // Re-enable gesture
                                }
                        } else if step == 3 && offset.width > swipeThreshold {
                            // Swipe Right Success
                            isAnimatingReset = true // Disable gesture
                            withAnimation(.spring()) {
                                // Animate far off-screen right
                                offset = CGSize(width: screenWidth, height: 0)
                            }
                            // Schedule reset after 1 second
                            DispatchQueue.main
                                .asyncAfter(deadline: .now() + 1.0) {
                                    step += 1 // Move to next instruction
                                    // Reset offset (will animate back)
                                    offset = .zero
                                    isAnimatingReset = false // Re-enable gesture
                                }
                        } else {
                            // If swipe wasn't decisive or wrong direction for the step,
                            // snap back to center. Only animate if actually moved.
                            if offset != .zero {
                                withAnimation(.spring()) {
                                    offset = .zero
                                }
                            }
                        }
                    }
            )
            // Apply the animation modifier to the view affected by offset changes
            .animation(.spring(), value: offset)

            // Show "Next" button only for step 1
            if step == 1 {
                Button("Next") {
                    step += 1
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
                .transition(.scale.combined(with: .opacity)) // Add transition
            }

            Spacer()

            // Show completion text only for step 4
            if step == 4 {
                Text("You're all set! Start discovering recipes!")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
                    .transition(
                        .scale.combined(with: .opacity)
                    ) // Add transition
            }
        }
        .padding()
        .navigationTitle("How It Works")
        .animation(.easeInOut, value: step)
    }

    var instructionText: String {
        switch step {
        case 0: return "Tap the recipe card to open its source." // Updated text slightly
        case 1: return "Great! Now tap 'Next' to continue."
        case 2: return "Swipe left on the card to discard the recipe."
        case 3: return "Good! Now swipe right to save it to your cookbook!"
        default: return "You're ready to go!"
        }
    }
}


#Preview {
    OnboardingHowToView()
}
