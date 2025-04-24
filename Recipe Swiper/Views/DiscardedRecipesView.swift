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
                Text(recipe.title)
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
