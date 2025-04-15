//
//  SavedRecipesView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI

struct SavedRecipesView: View {
    var savedRecipes: [String]

    var body: some View {
        NavigationStack {
            List(savedRecipes, id: \.self) { recipe in
                Text(recipe)
            }
            .navigationTitle("Saved Recipes")
        }
    }
}

#Preview {
    SavedRecipesView(savedRecipes: ["Sushi", "Tacos"])
}
