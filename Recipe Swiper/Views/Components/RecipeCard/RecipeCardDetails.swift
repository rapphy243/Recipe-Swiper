//
//  RecipeCardDetails.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/24/25.
//

import SwiftUI

struct RecipeCardDetails: View {
    @ObservedObject var recipe: Recipe
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                TimeTag(minutes: recipe.readyInMinutes)
                ServingsTag(servings: recipe.servings)
            }

            HStack {
                SourceTag(source: recipe.sourceUrl ?? "")
            }

            HStack(spacing: 8) {
                CuisineTags(
                    cuisines: recipe.cuisines,
                    showAll: false
                )
            }

            HStack(spacing: 8) {
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
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}

#Preview {
    RecipeCardDetails(recipe: Recipe.Cake)
}
