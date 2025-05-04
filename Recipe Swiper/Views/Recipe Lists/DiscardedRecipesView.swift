//
//  DiscardedRecipesView.swift
//  Recipe Swiper
//
//  Created by Tyler Berlin on 4/21/25.
//

import SwiftData
import SwiftUI

struct DiscardedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var sortOrder = SortDescriptor(\RecipeModel.dateModified)
    @State private var isEditing: Bool = false
    @Query(filter: #Predicate<RecipeModel> { $0.isDiscarded })
    private var discardedRecipes: [RecipeModel]

    var body: some View {
        NavigationStack {
            RecipeListView(
                sort: sortOrder,
                isEditing: isEditing,
                isDiscardedView: true
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !discardedRecipes.isEmpty {
                        Menu {
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
                if discardedRecipes.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label(
                                "No discarded recipes",
                                systemImage: "list.bullet.rectangle.portrait"
                            )
                        },
                        description: {
                            Text(
                                "Recipes you swipe left on will appear here. \n Only the last 10 discarded recipes will be shown."
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
    let recipe1 = RecipeModel(from: loadCakeRecipe(), isDiscarded: true)
    let recipe2 = RecipeModel(from: loadCurryRecipe(), isDiscarded: true)
    let recipe3 = RecipeModel(from: loadSaladRecipe(), isDiscarded: true)
    container.mainContext.insert(recipe1)
    container.mainContext.insert(recipe2)
    container.mainContext.insert(recipe3)

    return DiscardedRecipesView()
        .modelContainer(container)
}
