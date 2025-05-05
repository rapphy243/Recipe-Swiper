//
//  OnboardingHowToView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI

struct OnboardingHowToView: View {
    @Binding var recipe: Recipe
    @State private var offset: CGSize = .zero
    @State private var step = 0
    @State private var isAnimatingReset = false  // To disable gesture during reset
    @Binding var selectedTab: Int

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text(instructionText)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
                .id(step)  // Add ID to force text update animation
                .transition(.opacity)

            SmallRecipeCard(recipe: recipe)
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
                            let swipeThreshold: CGFloat = 50  // Min distance for a swipe

                            if step == 2 && offset.width < -swipeThreshold {
                                // Swipe Left Success
                                isAnimatingReset = true  // Disable gesture
                                let impact = UIImpactFeedbackGenerator(style: .soft)
                                impact.impactOccurred()
                                withAnimation(.spring()) {
                                    // Animate far off-screen left
                                    offset = CGSize(
                                        width: -screenWidth,
                                        height: 0
                                    )
                                }
                                // Schedule reset after 1 second
                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 1.0
                                ) {
                                    step += 1  // Move to next instruction
                                    // Reset offset (will animate back due to .animation modifier)
                                    offset = .zero
                                    isAnimatingReset = false  // Re-enable gesture
                                }
                            } else if step == 3 && offset.width > swipeThreshold
                            {
                                // Swipe Right Success
                                isAnimatingReset = true  // Disable gesture
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                withAnimation(.spring()) {
                                    // Animate far off-screen right
                                    offset = CGSize(
                                        width: screenWidth,
                                        height: 0
                                    )
                                }
                                // Schedule reset after 1 second
                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 1.0
                                ) {
                                    step += 1  // Move to next instruction
                                    // Reset offset (will animate back)
                                    offset = .zero
                                    isAnimatingReset = false  // Re-enable gesture
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
            // Show "Next" button only for step 0 and 1
            if step == 0 || step == 1 {
                Button("Next") {
                    step += 1
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
                .transition(.scale.combined(with: .opacity))  // Add transition
            }

            Spacer()
        }
        .navigationTitle("How It Works")
        .animation(.easeInOut, value: step)
        .onChange(of: step) { _, newStep in
            if newStep == 4 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    selectedTab = 3  // Move to next tab in Onboarding
                }
            }
        }
    }

    var instructionText: String {
        switch step {
        case 0:
            return
                "This is what a recipe looks like.\nLet's learn how to interact with it!"
        case 1:
            return "You can tap on the URL inside the card to view the source!"
        case 2: return "Swipe left on the card to discard the recipe."
        case 3: return "Good! Now swipe right to save it to your cookbook!"
        default: return "You're ready to go!"
        }
    }
}

#Preview {
    @Previewable @State var selectedTab: Int = 1
    @Previewable @State var recipe = loadCakeRecipe()
    OnboardingHowToView(recipe: $recipe, selectedTab: $selectedTab)
}
