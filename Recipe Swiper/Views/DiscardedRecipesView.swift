//
//  DiscaredRecipiesView.swift
//  Recipe Swiper
//
//  Created by Tyler Berlin on 4/21/25.
//

import SwiftUI
import SwiftData

struct DiscardedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \RecipeModel.dateModified) private var discardedRecipes: [RecipeModel]
    var body: some View {
        NavigationStack {
            List(discardedRecipes) { recipe in
                NavigationLink(destination: FullRecipe(recipe: recipe)) {
                    HStack {
                        AsyncImage(url: URL(string: recipe.image ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(10)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                        }
                        Text(recipe.title)
                            .font(.headline)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
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
        .onAppear {
                    print("Saved recipes count: \(discardedRecipes.count)")
            discardedRecipes.forEach {
                print("Recipe: \($0.title), isDiscarded: \($0.isDiscarded)")}
                }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RecipeModel.self, configurations: config)
    let recipe1 = RecipeModel(from: loadCakeRecipe(), isDiscarded: true)
    let recipe2 = RecipeModel(from: loadCurryRecipe(), isDiscarded: true)
    let recipe3 = RecipeModel(from: loadSaladRecipe(), isDiscarded: true)
    container.mainContext.insert(recipe1)
    container.mainContext.insert(recipe2)
    container.mainContext.insert(recipe3)
    
    return DiscardedRecipesView()
        .modelContainer(container)
}
