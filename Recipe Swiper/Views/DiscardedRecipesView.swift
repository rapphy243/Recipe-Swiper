//
//  DiscaredRecipiesView.swift
//  Recipe Swiper
//
//  Created by Tyler Berlin on 4/21/25.
//

import SwiftUI

struct DiscardedRecipesView: View {
    @Binding var discardedRecipes: [Recipe]
    @Binding var savedRecipes: [Recipe]
    @State private var isEditing: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(discardedRecipes, id: \.self) { recipe in
                    HStack {
                        if isEditing {
                            Button(action: {
                                withAnimation {
                                    if let index = discardedRecipes.firstIndex(of: recipe) {
                                        let restoredRecipe = discardedRecipes.remove(at: index)
                                        savedRecipes.append(restoredRecipe)
                                    }
                                }
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.green)
                            }
                            .padding(.trailing, 8)
                        }
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
                        }
                    }
                }
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
    @Previewable @State var discardedRecipes: [Recipe] = [loadCakeRecipe(), loadCurryRecipe(), loadSaladRecipe()]
    @Previewable @State var savedRecipes: [Recipe] = []
    DiscardedRecipesView(discardedRecipes: $discardedRecipes, savedRecipes: $savedRecipes)
}
