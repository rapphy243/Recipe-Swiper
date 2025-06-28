//
//  SwipableRecipeCard.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/27/25.
//

import SwiftUI

struct SwipableRecipeCard: View {
    @State private var cardOffset: CGSize = .zero
    @State private var cardRotation: Double = 0
    
    // Swipe threshold to trigger action
    private let swipeThreshold: CGFloat = 200
    var body: some View {
        RecipeCard()
            .offset(cardOffset)
            .rotationEffect(.degrees(cardRotation))
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        cardOffset = gesture.translation
                        // Add slight rotation based on horizontal movement
                        cardRotation = Double(
                            gesture.translation.width / 15
                        )
                    }
                    .onEnded { gesture in
                        handleSwipe(gesture)
                    }
            )
            .overlay(alignment: .trailing) {
                if cardOffset.width > 50 {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.green)
                        .font(.largeTitle)
                        .padding(.trailing, 30)
                        .opacity(
                            Double(cardOffset.width)
                                / swipeThreshold
                        )
                }
            }
            .overlay(alignment: .leading) {
                if cardOffset.width < -50 {
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .font(.largeTitle)
                        .padding(.leading, 30)
                        .opacity(
                            Double(-cardOffset.width)
                                / swipeThreshold
                        )
                }
            }
            .animation(
                .spring(response: 0.3),
                value: cardOffset
            )
    }

    private func handleSwipe(_ gesture: DragGesture.Value) {
        let horizontalMovement = gesture.translation.width

        // Right swipe (save)
        if horizontalMovement > swipeThreshold {
            let impactMed = UIImpactFeedbackGenerator(style: .medium)
            impactMed.impactOccurred()
            Task {
                try! await Task.sleep(nanoseconds: 1_000_000_000)
                resetCardPosition()
            }
        }
        // Left swipe (skip)
        else if horizontalMovement < -swipeThreshold {
            let impactLight = UIImpactFeedbackGenerator(style: .light)
            impactLight.impactOccurred()
            Task {
                try! await Task.sleep(nanoseconds: 1_000_000_000)
                resetCardPosition()
            }
        }
        // Not enough movement - reset position
        else {
            resetCardPosition()
            let impactMed = UIImpactFeedbackGenerator(style: .heavy)
            impactMed.impactOccurred()
        }
    }

    private func resetCardPosition() {
        withAnimation(.spring(response: 0.3)) {
            cardOffset = .zero
            cardRotation = 0
        }
    }
}

#Preview {
    SwipableRecipeCard()
}
