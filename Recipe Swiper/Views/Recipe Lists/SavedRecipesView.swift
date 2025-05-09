//
//  SavedRecipesView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftData
import SwiftUI

struct SavedRecipesView: View {
    //Lets you access the color scheme depending on the system settings
    @Environment(\.colorScheme) private var colorScheme
    //Lets you access the model context for the current view
    @Environment(\.modelContext) private var modelContext
    @State private var sortOrder = SortDescriptor(
        \RecipeModel.dateModified,
         order: .reverse
    )
    @State private var filterBy: String = "All"
    //Only shows recipes that were saved
    @Query(filter: #Predicate<RecipeModel> { !$0.isDiscarded })
    private var savedRecipes: [RecipeModel]
    
    var body: some View {
        NavigationStack {
            RecipeListView(
                sort: sortOrder,
                filter: filterBy,
                isDiscardedView: false
            )
            //Adds a menu to the top right of the screen to sort the recipes
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
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(
                                    colorScheme == .light ? .black : .white
                                )
                        }
                    }
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            //Shows message if there are no saved recipes
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
