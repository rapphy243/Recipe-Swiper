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
    @State private var sortOrder = SortDescriptor(
        \RecipeModel.dateModified,
        order: .reverse
    )
    @State private var filterBy: String = "All"
    @State private var isEditing: Bool = false
    @Query(filter: #Predicate<RecipeModel> { !$0.isDiscarded })
    private var savedRecipes: [RecipeModel]
    var body: some View {
        NavigationStack {
            RecipeListView(
                sort: sortOrder,
                filter: filterBy,
                isEditing: isEditing,
                isDiscardedView: false
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !savedRecipes.isEmpty {
                        Menu {
                            Picker(
                                selection: $sortOrder,
                                content: {
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
                                },
                                label: {
                                    HStack {
                                        Text("Sort")
                                        Spacer()
                                        Image(
                                            systemName:
                                                "line.2.horizontal.decrease.circle"
                                        )
                                    }
                                }
                            )
                            .pickerStyle(.menu)
                            Picker(
                                selection: $filterBy,
                                content: {
                                    Text("All Recipes")
                                        .tag("All")
                                    Text("Has Rating")
                                        .tag("Rating")
                                },
                                label: {
                                    HStack {
                                        Text("Filter")
                                        Spacer()
                                        Image(
                                            systemName:
                                                "line.2.horizontal.decrease.circle"
                                        )
                                    }
                                }

                            )
                            .pickerStyle(.menu)

                            Divider()
                            Button(isEditing ? "Done" : "Edit") {
                                withAnimation {
                                    isEditing.toggle()
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .toolbarBackground(.indigo, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .overlay {
                if savedRecipes.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label(
                                "No saved recipes yet",
                                systemImage: "book.closed.fill"
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
