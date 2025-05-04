//
//  SavedRecipesView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftData
import SwiftUI

struct SavedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var sortOrder = SortDescriptor(\RecipeModel.dateModified)
    @State private var isEditing: Bool = false
    @Query(filter: #Predicate<RecipeModel> { !$0.isDiscarded })
    private var savedRecipes: [RecipeModel]
    var body: some View {
        NavigationStack {
            RecipeListView(
                sort: sortOrder,
                isEditing: isEditing,
                isDiscardedView: false
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !savedRecipes.isEmpty {
                        Menu {
                            Picker("Sort", selection: $sortOrder) {
                                Text("Most Recent")
                                    .tag(
                                        SortDescriptor(
                                            \RecipeModel.dateModified,
                                            order: .reverse
                                        )
                                    )
                                Text("Oldest First")
                                    .tag(
                                        SortDescriptor(
                                            \RecipeModel.dateModified,
                                            order: .forward
                                        )
                                    )
                                Text("By Title")
                                    .tag(SortDescriptor(\RecipeModel.title))
                                Text("By Rating")
                                    .tag(
                                        SortDescriptor(
                                            \RecipeModel.rating,
                                            order: .reverse
                                        )
                                    )
                            }
                            Divider()
                            Button(isEditing ? "Done" : "Edit") {
                                withAnimation {
                                    isEditing.toggle()
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .overlay {
                if savedRecipes.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label(
                                "No saved recipes yet",
                                systemImage: "list.bullet.rectangle.portrait"
                            )
                        },
                        description: {
                            Text(
                                "Start saving recipes by swiping right on them in the Home feed."
                            )
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: RecipeModel.self,
        configurations: config
    )
    let recipe1 = RecipeModel(from: loadCakeRecipe(), isDiscarded: false)
    let recipe2 = RecipeModel(from: loadCurryRecipe(), isDiscarded: false)
    let recipe3 = RecipeModel(from: loadSaladRecipe(), isDiscarded: false)
    container.mainContext.insert(recipe1)
    container.mainContext.insert(recipe2)
    container.mainContext.insert(recipe3)

    return SavedRecipesView()
        .modelContainer(container)
}
