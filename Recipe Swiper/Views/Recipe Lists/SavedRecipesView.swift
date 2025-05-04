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
    @State private var sortOrder = SortOrder.dateDesc
    @State private var isEditing: Bool = false

    var savedRecipes: [RecipeModel] {
        try! modelContext.fetch(
            FetchDescriptor<RecipeModel>(
                predicate: #Predicate<RecipeModel> { !$0.isDiscarded },
                sortBy: [sortOrder.sortDescriptor]
            )
        )
    }

    var body: some View {
        NavigationStack {
            HStack {
                List {
                    ForEach(savedRecipes, id: \.self) { recipe in
                        HStack {
                            if isEditing {
                                withAnimation {
                                    Button(action: {
                                        recipe.isDiscarded = true
                                    }) {
                                        Image(systemName: "minus.circle")
                                            .foregroundColor(.red)
                                            .padding(.trailing)
                                    }
                                }
                            }
                            if !isEditing {
                                NavigationLink(
                                    destination: FullRecipe(recipe: recipe)
                                ) {
                                    RecipelistItem(recipe: recipe)
                                }

                            }
                            else {
                                RecipelistItem(recipe: recipe)
                            }
                        }
                        .animation(.smooth, value: isEditing)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !savedRecipes.isEmpty {
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
