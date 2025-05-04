//
//  Stars.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/27/25.
//

import SwiftUI

struct RatingComponent: View {
    @Bindable var recipe: RecipeModel
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Rate this Recipe")
                .font(.title2)
                .bold()
                .padding(.top)
            HStack(spacing: 0) {
                ForEach(1...5, id: \.self) { star in
                    ZStack {
                        // Full star background (gray)
                        Image(systemName: "star.fill")
                            .foregroundColor(.gray.opacity(0.3))
                        // Filled star overlay
                        HStack {
                            Rectangle()
                                .fill(.yellow)
                                .frame(width: getStarFillWidth(for: star))
                                .mask {
                                    Image(systemName: "star.fill")
                                }
                        }
                    }
                    .font(.title)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                // Calculate rating based on drag position
                                updateRating(at: value.location, in: star)
                            }
                    )
                }
            }
            .frame(height: 40)
        }
    }

    private func getStarFillWidth(for star: Int) -> CGFloat {
        let starWidth = UIScreen.main.bounds.width / 12  // Approximate star width
        let rating = Double(recipe.rating)
        let starRating = rating - Double(star - 1)

        if starRating >= 1 {
            return starWidth
        } else if starRating > 0 {
            return starWidth * starRating
        }
        return 0
    }

    private func updateRating(at location: CGPoint, in star: Int) {
        let starWidth = UIScreen.main.bounds.width / 12
        let fillPercentage = max(0, min(1, location.x / starWidth))
        let newRating = Double(star - 1) + fillPercentage
        recipe.rating = Double(Int(round(newRating * 2)))  // Multiply by 2 to store half-stars
    }
}

#Preview {
    @Previewable @State var recipe = RecipeModel(from: loadCakeRecipe())
    RatingComponent(recipe: recipe)
}
