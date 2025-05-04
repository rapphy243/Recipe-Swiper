//
//  Stars.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/27/25.
//
//  Generated with Claude 2.5

import SwiftUI

struct RatingComponent: View {
    @Bindable var recipe: RecipeModel

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("Rate this Recipe")
                .font(.title2)
                .bold()
                .padding(.top)
            HStack(spacing: 15) {
                ForEach(1...5, id: \.self) { star in
                    Image(systemName: "star.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(
                            .linearGradient( // Hacky solution to get half stars
                                stops: [
                                    .init(color: .yellow, location: 0), // No star
                                    .init(// Half star
                                        color: .yellow,
                                        location: getStarFillPercentage(
                                            for: star
                                        )
                                    ),
                                    .init( // Full star
                                        color: .gray.opacity(0.3),
                                        location: getStarFillPercentage(
                                            for: star
                                        )
                                    ),
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 30)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    updateRating(
                                        at: value.location,
                                        in: star,
                                        starWidth: 30
                                    )
                                }
                        )
                }
            }
            .frame(height: 35)
        }
    }

    private func getStarFillPercentage(for star: Int) -> CGFloat {
        let rating = Double(recipe.rating) / 2.0  // Convert back to 0-5 range
        let starRating = rating - Double(star - 1)

        if starRating >= 1 {
            return 1
        } else if starRating > 0 {
            return CGFloat(starRating)
        }
        return 0
    }

    private func updateRating(
        at location: CGPoint,
        in star: Int,
        starWidth: CGFloat
    ) {
        let fillPercentage = max(0, min(1, location.x / starWidth))
        let newRating = Double(star - 1) + fillPercentage
        recipe.rating = Double(Int(round(newRating * 2)))  // Store as 0-10 for half-stars
    }
}

#Preview {
    @Previewable @State var recipe = RecipeModel(from: loadCakeRecipe())
    RatingComponent(recipe: recipe)
}
