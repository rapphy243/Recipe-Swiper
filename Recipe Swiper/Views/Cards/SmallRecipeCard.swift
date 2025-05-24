//
//  RecipeCardView.swift
//  Recipe Swiper
//
//  Created by Zane Matarieh on 4/15/25.
//

import SwiftData
import SwiftUI

struct SmallRecipeCard: View {
    @Environment(\.colorScheme) private var colorScheme
    let recipe: Recipe
    let onTap: (() -> Void)? = nil
    var body: some View {
        CardComponent {
            VStack(spacing: 5) {
                Text(recipe.title)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                Divider()
                GeometryReader { geometry in
                    HStack {
                        AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 0.5, height: 260)
                                .clipped()
                                .cornerRadius(10)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: geometry.size.width * 0.5, height: 260)
                        }
                        VStack {
                            SmallCardDetails(recipe: recipe)
                            Divider()
                                .frame(width: geometry.size.width * 0.35)
                            ScrollView {
                                Text("\(simplifySummary(recipe.summary))")
                                    .font(.caption2)
                                    .padding()
                            }
                            .frame(height: 100)
                        }
                    }
                }
                .padding(.top)
            }
            .frame(height: 380)
            .padding(.vertical)
        }
    }
}

#Preview {
    SmallRecipeCard(recipe: loadSaladRecipe())
}
