//
//  DiscaredRecipiesView.swift
//  Recipe Swiper
//
//  Created by Tyler Berlin on 4/21/25.
//

import SwiftData
import SwiftUI

struct DiscardedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: #Predicate<RecipeModel> { $0.isDiscarded },
        sort: \RecipeModel.dateModified, order: .forward)
    private var discardedRecipes: [RecipeModel]
    var body: some View {
        NavigationStack {
            List(discardedRecipes) { recipe in
                NavigationLink(destination: FullRecipe(recipe: recipe)) {
                    HStack {
                        if let imageData = recipe.imageData {
                            if let image = UIImage(data: imageData) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .clipped()
                                    .cornerRadius(10)
                            }
                        }
                        else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 60, height: 60)
                                .onAppear {
                                    Task {
                                        await recipe.getImage()
                                    }
                            }
                        }
                        Text(recipe.title)
                            .font(.headline)
                        Spacer()
                    }
                    .contentShape(Rectangle())
                }
                .swipeActions {
                    Button {
                        recipe.dateModified = Date()
                        recipe.isDiscarded = false
                    } label: {
                        Label("Save", systemImage: "bookmark")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Done" : "Edit") {
                        withAnimation {
                            isEditing.toggle()
                        }
                    }
                }
            }
        }
        .overlay {
            if discardedRecipes.isEmpty {
                ContentUnavailableView(label: {
                    Label("No discarded recipes", systemImage: "trash")
                }, description: {
                    Text("Only the last 10 discarded recipes will be saved here.")
                })
            }
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
