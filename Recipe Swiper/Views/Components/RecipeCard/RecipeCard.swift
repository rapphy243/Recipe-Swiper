//
//  RecipeCard.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/23/25.
//

import SwiftUI

struct RecipeCard: View {
    var body: some View {
        VStack {
            Card {
                VStack(spacing: 5) {
                    Text("Title of Recipe")
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
                                        "https://img.spoonacular.com/recipes/653836-556x370.jpg"
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
                            VStack {
                                RecipeCardDetails()
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
                                    // This would be a perfect spot to use new AI features.
                                    Text("blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. blah blah blah cool recipe details. ")
                                        .font(.caption)
                                }
                                // TODO: Fix size to image wsize
                                .containerRelativeFrame(
                                    .vertical,
                                    { height, _ in
                                        return height * 0.2
                                    }
                                )
                                .containerRelativeFrame(
                                    .horizontal,
                                    { width, _ in
                                        return width * 0.30
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
}

#Preview {
    RecipeCard()
}
