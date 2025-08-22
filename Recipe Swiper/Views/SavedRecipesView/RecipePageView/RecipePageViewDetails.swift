//
//  CardDetails.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/19/25.
//

import SwiftUI

struct RecipePageViewDetails: View {
    @Environment(\.colorScheme) private var colorScheme
    var recipe: RecipeModel

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                SourceTag(source: recipe.sourceUrl ?? "")
                Divider()
                    .frame(maxHeight: 30)

                TimeTag(minutes: recipe.readyInMinutes)
                Divider()
                    .frame(maxHeight: 30)

                ServingsTag(servings: recipe.servings)
                Divider()
                    .frame(maxHeight: 30)
                // Health Score
                HealthTag(healthScore: recipe.healthScore)
            }
            HStack(spacing: 10) {
                if !recipe.cuisines.isEmpty {
                    CuisineTags(cuisines: recipe.cuisines, showAll: true)
                }

                if recipe.vegan {
                    VeganTag()
                }

                if recipe.vegetarian {
                    VeganTag()
                if recipe.vegetarian {
                    VegetarianTag()
                }

                if recipe.glutenFree {
                    GlutenFreeTag()
                }

                if recipe.dairyFree {
                    DairyFreeTag()
                }
            }
        }
        .padding()
        .cornerRadius(8)
    }
}
#Preview {
    RecipePageView(recipe: RecipeModel(from: Recipe.Cake))
}
