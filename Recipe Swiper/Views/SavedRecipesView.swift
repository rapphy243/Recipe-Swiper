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
                Text(recipe.title)
            }
        }
    }
}

#Preview {
    @Previewable @State var savedRecipes: [Recipe] = [ loadCakeRecipe(), loadCurryRecipe(), loadSaladRecipe()]
    SavedRecipesView(savedRecipes: savedRecipes)
}
