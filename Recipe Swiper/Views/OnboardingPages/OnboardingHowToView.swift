//
//  OnboardingHowToView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI

struct OnboardingHowToView: View {
    @State private var recipe: Recipe? = RecipeLoader.shared.cake
    @State private var offset: CGSize = .zero
    @State private var step = 0
    @State private var cardRemoved = false

    var body: some View {
        VStack(spacing: 20) {
            Text(instructionText)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            RecipeCardView(recipe: recipe!) {
                if step == 0, let url = URL(string: (recipe?.sourceUrl!)!) {
                    UIApplication.shared.open(url)
                    step += 1
                }
            }
            .offset(offset)
            .rotationEffect(.degrees(Double(offset.width / 20)))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if step >= 2 {
                            offset = gesture.translation
                        }
                    }
                    .onEnded { _ in
                        if step == 2 && offset.width < -100 {
                            cardRemoved = true
                            step += 1
                        } else if step == 3 && offset.width > 100 {
                            cardRemoved = true
                            step += 1
                        } else {
                            offset = .zero
                        }
                    }
            )
            .animation(.spring(), value: offset)
            if step == 1 {
                Button("Next") {
                    step += 1
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
            }
            
            Spacer()

            if step == 4 {
                Text("You're all set! Start discovering recipes!")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .padding()
        .navigationTitle("How It Works")
    }

    var instructionText: String {
        switch step {
        case 0: return "Tap the recipe card to open it in Safari."
        case 1: return "Now tap 'Next' to continue."
        case 2: return "Swipe left to discard the recipe."
        case 3: return "Swipe right to save it to your cookbook!"
        default: return "You're ready to go!"
        }
    }
}



#Preview {
    OnboardingHowToView()
}
