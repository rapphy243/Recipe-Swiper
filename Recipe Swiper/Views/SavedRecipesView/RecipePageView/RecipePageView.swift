//
//  RecipePageView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 8/2/25.
//

import SwiftUI

struct RecipePageView: View {
    @Bindable var recipe: RecipeModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    if let imageData = recipe.imageData,
                        let uiImage = UIImage(data: imageData)
                    {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .padding()
                    } else { // Show placeholder
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 300)
                            .padding()
                    }

                    SectionTitleView(title: "Details")
                    RecipePageViewDetails(recipe: recipe)
                    // Adjustable rating
                    HStack {
                        Button(action: {
                            if recipe.rating > 0 { recipe.rating -= 1 }
                        }) {
                            Image(systemName: "minus.circle.fill").font(
                                .system(size: 25)
                            )
                        }
                        RatingTag(rating: recipe.rating)
                            .font(.system(size: 35))
                        Button(action: {
                            if recipe.rating < 10 { recipe.rating += 1 }
                        }) {
                            Image(systemName: "plus.circle.fill").font(
                                .system(size: 25)
                            )
                        }
                    }

                    Divider()

                    SectionTitleView(title: "Summary")

                    Text(recipe.summary)
                        .font(.body)
                        .padding(.horizontal)

                    Divider()

                    SectionTitleView(title: "Ingredients")

                    RecipePageIngredientsList(recipe: recipe)

                    Divider()

                    SectionTitleView(title: "Instructions")

                    RecipePageInstructions(recipe: recipe)

                }
            }
            .navigationTitle(recipe.title)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        EditableRecipePageView(recipe: recipe)
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
    }
}

struct SectionTitleView: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.title2)
            .bold()
            .multilineTextAlignment(.center)
    }
}

#Preview {
    RecipePageView(recipe: RecipeModel(from: Recipe.Cake))
}
