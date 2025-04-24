//
//  DiscaredRecipiesView.swift
//  Recipe Swiper
//
//  Created by Tyler Berlin on 4/21/25.
//

import SwiftUI

struct DiscardedRecipesView: View {
    @Binding var discardedRecipes: [Recipe]
    var body: some View {
        NavigationStack {
            List(discardedRecipes, id: \.self) { recipe in
                NavigationLink(destination: FullRecipe(recipe: recipe)) {
                    HStack {
                        AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(10)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                        }
                        Text(recipe.title)
                            .font(.headline)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
            }
        }
        .overlay {
            if discardedRecipes.isEmpty {
                ContentUnavailableView(label: {
                Label("No discarded recipes", systemImage: "trash")
                }, description : {
                    Text("Only the last 10 discarded recipes will be saved here.")
                })
            }
        }
    }
}

#Preview {
    @Previewable @State var discardedRecipes: [Recipe] = [loadCakeRecipe(), loadCurryRecipe(), loadSaladRecipe()]
    DiscardedRecipesView(discardedRecipes: $discardedRecipes)
}
