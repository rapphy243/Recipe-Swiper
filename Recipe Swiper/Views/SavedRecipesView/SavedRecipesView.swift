//
//  SavedRecipesView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftUI
import SwiftData

struct SavedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\RecipeModel.dateModified, order: .forward)])
        var recipeList: [RecipeModel]
    var body: some View {
        NavigationStack {
            List {
                ForEach(recipeList, id: \.self) { recipe in
                    RecipeListItem(recipe: recipe)
                }
            }
            .navigationTitle("Saved Recipes")
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
    container.mainContext.insert(recipe1)
    
    return SavedRecipesView()
        .modelContainer(container)
}
