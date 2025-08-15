//
//  RecipeListItem.swift
//  Recipe Swiper
//
//  Created by Tyler Berlin on 6/28/25.
//

import SwiftData
import SwiftUI

struct RecipeListItem: View {
    @StateObject var recipe: RecipeModel
    var body: some View {
        HStack(spacing: 15) {
            if let imageData = recipe.imageData {
                if let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 75, height: 75)
                        .clipped()
                        .cornerRadius(10)
                }
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 70, height: 75)
                    .onAppear {
                        Task {
                            await recipe.getImage()
                        }
                    }
            }
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .font(.headline)
                    .minimumScaleFactor(0.8)
                    .lineLimit(2)
                HStack {
                    SourceTag(source: recipe.sourceUrl ?? "")
                    ServingsTag(servings: recipe.servings)
                }
                .font(.caption)
                if recipe.rating > 0 {  // Checking for a rating
                    RatingTag(rating: recipe.rating)
                } else if recipe.dairyFree || recipe.glutenFree || recipe.vegan
                    || recipe.vegetarian
                {
                    HStack {
                        if recipe.vegetarian {
                            VegetarianTag()
                        }
                        if recipe.vegan {
                            VeganTag()
                        }
                        if recipe.glutenFree {
                            GlutenFreeTag()
                        }
                        if recipe.dairyFree {
                            DairyFreeTag()
                        }
                    }
                } else {
                    CuisineTags(cuisines: recipe.cuisines, showAll: true)
                        .font(.caption)
                        .lineLimit(1)
                }
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: RecipeModel.self,
        configurations: config
    )
    let recipe1 = RecipeModel(from: Recipe.Cake)
    recipe1.glutenFree = true
    recipe1.vegan = true
    recipe1.dairyFree = true
    recipe1.vegetarian = true
    recipe1.rating = 5
    container.mainContext.insert(recipe1)

    return SavedRecipesView(SearchText: .constant(""))
        .modelContainer(container)
}
