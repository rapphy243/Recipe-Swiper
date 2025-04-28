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
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Image(
                        systemName: star <= (recipe.rating) ? "star.fill" : "star"
                    )
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        recipe.rating = star
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var recipe = RecipeModel(from: loadCakeRecipe())
    RatingComponent(recipe: recipe)
}
