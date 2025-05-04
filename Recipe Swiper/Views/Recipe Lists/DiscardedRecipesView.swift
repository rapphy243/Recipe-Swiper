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
    @State private var sortOrder = SortOrder.dateDesc
    @State private var isEditing: Bool = false

    var discardedRecipes: [RecipeModel] {
        try! modelContext.fetch(
            FetchDescriptor<RecipeModel>(
                predicate: #Predicate<RecipeModel> { $0.isDiscarded },
                sortBy: [sortOrder.sortDescriptor]
            )
        )
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(discardedRecipes, id: \.self) { recipe in
                    HStack(spacing: 0) {
                        if isEditing {
                            Button(action: {
                                recipe.isDiscarded = false
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .padding(.trailing)
                            }
                        }
                        
                        if isEditing {
                            RecipelistItem(recipe: recipe, showRating: false)
                        } else {
                            NavigationLink(
                                destination: FullRecipe(recipe: recipe)
                            ) {
                                RecipelistItem(recipe: recipe, showRating: false)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !discardedRecipes.isEmpty {
                        Menu {
                            Button("Most Recent") {
                                sortOrder = .dateDesc
                            }
                            Button("Oldest First") {
                                sortOrder = .dateAsc
                            }
                            Button("By Title") {
                                sortOrder = .title
                            }
                            Button("By Rating") {
                                sortOrder = .rating
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
                if discardedRecipes.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label(
                                "No discarded recipes",
                                systemImage: "list.bullet.rectangle.portrait"
                            )
                        },
                        description: {
                            Text("Recipes you swipe left on will appear here. \n Only the last 10 discarded recipes will be shown.")
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
