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
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationStack {
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
                }
            }
            .toolbar {
                if !savedRecipes.isEmpty {
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
                if savedRecipes.isEmpty {
                    ContentUnavailableView(label: {
                        Label("No saved recipes yet", systemImage: "list.bullet.rectangle.portrait")
                    }, description: {
                        Text("Start saving recipes by swiping right on them in the Home feed.")
                    })
                }
            }
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
