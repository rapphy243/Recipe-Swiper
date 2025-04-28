//
//  SavedRecipesView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI
import SwiftData

struct SavedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<RecipeModel> {!$0.isDiscarded})
       private var savedRecipes: [RecipeModel]
    var body: some View {
        NavigationStack {
            List(savedRecipes, id: \.self) { recipe in
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
            if savedRecipes.isEmpty {
                ContentUnavailableView(label: {
                Label("No saved recipes yet", systemImage: "list.bullet.rectangle.portrait")
                }, description : {
                    Text("Start saving recipes by swiping right on them in the Home feed.")
                })
            }
        }
        .onAppear {
                    print("Saved recipes count: \(savedRecipes.count)")
                    savedRecipes.forEach { print("Recipe: \($0.title), isDiscarded: \($0.isDiscarded)") }
            }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: RecipeModel.self, configurations: config)
    let recipe1 = RecipeModel(from: loadCakeRecipe(), isDiscarded: false)
    let recipe2 = RecipeModel(from: loadCurryRecipe(), isDiscarded: false)
    let recipe3 = RecipeModel(from: loadSaladRecipe(), isDiscarded: false)
    container.mainContext.insert(recipe1)
    container.mainContext.insert(recipe2)
    container.mainContext.insert(recipe3)
    
    return SavedRecipesView()
        .modelContainer(container)
}
