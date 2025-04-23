//
//  SavedRecipesView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI

struct SavedRecipesView: View {
    var savedRecipes: [Recipe]

    var body: some View {
        NavigationStack {
            List(savedRecipes, id: \.self) { recipe in
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
                    Image(systemName: "chevron.right")
                }
                .contentShape(Rectangle())
            }
        }
        .overlay {
            if savedRecipes.isEmpty {
                ContentUnavailableView(label: {
                Label("No saved recipes yet", systemImage: "list.bullet.rectangle.portrait")
                }, description : {
                    Text("Start saving recipes by swiping right on them in the Home feed.")
                })
            }
        }
    }
}

#Preview {
    @Previewable @State var savedRecipes: [Recipe] = [ loadCakeRecipe(), loadCurryRecipe(), loadSaladRecipe()]
    SavedRecipesView(savedRecipes: savedRecipes)
}
