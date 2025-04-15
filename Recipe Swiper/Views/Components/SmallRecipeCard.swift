//
//  RecipeCardView.swift
//  Recipe Swiper
//
//  Created by Zane Matarieh on 4/15/25.
//

import Foundation
import SwiftUI

struct SmallRecipeCardView: View {
    let recipe: Recipe
    var onTap: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 10) {
            Text(recipe.title)
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)

            Divider()

            HStack {
                AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 200)
                        .clipped()
                        .cornerRadius(10)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 160, height: 200)
                }

                Spacer()

                VStack(alignment: .leading) {
                    Text("Ready in \(recipe.readyInMinutes) minutes")
                        .font(.headline)
                    Text("Serves \(recipe.servings)")
                        .font(.headline)
                }
                .padding(.vertical)
                .frame(maxHeight: 200)
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.orange.opacity(0.2))
                .shadow(radius: 5)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onTap?()
        }
        .padding(.horizontal)
    }
}

#Preview {
    SmallRecipeCardView(recipe: loadCakeRecipe())
}
