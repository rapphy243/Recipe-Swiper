//
//  RecipeCard.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/23/25.
//

import SwiftUI

struct RecipeCard: View {
    var body: some View {
        Card {
            VStack(spacing: 5) {
                Text("Title of Recipe")
                    .font(.title)
                    .bold()
                    .multilineTextAlignment(.center)
                Divider()
                    .containerRelativeFrame(
                        .horizontal,
                        { width, _ in
                            return width * 0.87
                        }
                    )
                HStack {
                    AsyncImage(
                        url: URL(
                            string:
                                "https://img.spoonacular.com/recipes/653836-556x370.jpg"
                        )
                    ) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 275)
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
                            .frame(height: 275)
                            .containerRelativeFrame(
                                .horizontal,
                                { width, _ in
                                    return width / 2
                                }
                            )
                    }
                    VStack {
                        Text("Recipe Details")
                        Divider()
                            .containerRelativeFrame(
                                .horizontal,
                                { width, _ in
                                    return width * 0.35
                                }
                            )
                        ScrollView {
                            Text("")
                                .font(.caption2)
                                .padding()
                        }
                        // TODO: Fix size to image wsize
                        .containerRelativeFrame(
                            .vertical,
                            { height, _ in
                                return height * 0.25
                            }
                        )
                        

                    }
                }
                .padding(.top)
            }

        }
    }
}

#Preview {
    RecipeCard()
}
