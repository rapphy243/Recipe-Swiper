//
//  RecipeCard.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/23/25.
//

import SwiftUI

struct RecipeCard: View {
    @ObservedObject var recipe: Recipe
    var body: some View {
        Card {
            VStack(spacing: 5) {
                Text(recipe.title)
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                Divider()
                    .containerRelativeFrame(
                        .horizontal,
                        { width, _ in
                            return width * 0.87
                        }
                    )
                VStack {
                    HStack {
                        AsyncImage(
                            url: URL(
                                string:
                                    recipe.image ?? ""
                            )
                        ) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 295)
                                .containerRelativeFrame(
                                    .horizontal,
                                    { width, _ in
                                        return width / 2
                                    }
                                )
                                .clipped()
                                .cornerRadius(10)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 295)
                                .containerRelativeFrame(
                                    .horizontal,
                                    { width, _ in
                                        return width / 2
                                    }
                                )
                        }
                        VStack(alignment: .center) {
                            RecipeCardDetails(recipe: recipe)
                                .containerRelativeFrame(
                                    .horizontal,
                                    { width, _ in
                                        return width * 0.35
                                    }
                                )
                            Divider()
                                .containerRelativeFrame(
                                    .horizontal,
                                    { width, _ in
                                        return width * 0.3
                                    }
                                )

                            ScrollView {
                                if let generatedSummary = recipe
                                    .generatedSummary
                                {
                                    Text(generatedSummary)
                                        .font(.caption)
                                } else {
                                    Text(recipe.summary)
                                        .font(.caption)
                                }
                            }
                            .containerRelativeFrame(
                                .vertical,
                                { height, _ in
                                    return height * 0.26
                                }
                            )
                            .containerRelativeFrame(
                                .horizontal,
                                { width, _ in
                                    return width * 0.31
                                }
                            )
                        }
                    }
                    .padding(.top)
                }
            }
        }
    }
}

#Preview {
    RecipeCard(recipe: Recipe.Cake)
}
