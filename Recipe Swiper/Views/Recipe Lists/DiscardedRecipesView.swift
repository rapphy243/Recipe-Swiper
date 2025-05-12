//
//  DiscardedRecipesView.swift
//  Recipe Swiper
//
//  Created by Tyler Berlin on 4/21/25.
//

import SwiftData
import SwiftUI

struct DiscardedRecipesView: View {
    //Determins if the user is in dark mode or light mode and displays the color mode matching your set mode.
    @Environment(\.colorScheme) private var colorScheme
    //Lets you access the model context letting you save, update and delete recipes
    @Environment(\.modelContext) private var modelContext
    //Shows the recipe most recently discared at the top
    @State private var sortOrder = SortDescriptor(
        \RecipeModel.dateModified,
         order: .reverse
    )
    //Only shows recipes that were discarded
    @Query(filter: #Predicate<RecipeModel> { $0.isDiscarded })
    private var discardedRecipes: [RecipeModel]
    
    var body: some View {
        NavigationStack {
            RecipeListView(
                sort: sortOrder,
                filter: "All",
                isDiscardedView: true
            )
            //Adds a menu to the top right of the screen to sort the recipes
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !discardedRecipes.isEmpty {
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
                            }
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
            //Shows message if there are no discarded recipes
            .overlay {
                if discardedRecipes.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label(
                                "No discarded recipes",
                                systemImage: "trash.fill"
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
