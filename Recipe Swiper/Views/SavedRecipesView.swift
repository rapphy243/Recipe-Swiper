//
//  SavedRecipesView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI

struct SavedRecipesView: View {
    @Binding var savedRecipes: [Recipe]
    @Binding var discardedRecipes: [Recipe]
    @State private var isEditing: Bool = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(savedRecipes, id: \.self) { recipe in
                    HStack {
                        if isEditing {
                            Button(action: {
                                withAnimation {
                                    if let index = savedRecipes.firstIndex(of: recipe) {
                                        let removedRecipe = savedRecipes.remove(at: index)
                                        discardedRecipes.append(removedRecipe)
                                    }
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
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
                        .buttonStyle(PlainButtonStyle()) // Prevents default button styling
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

#Preview {
    @Previewable @State var savedRecipes: [Recipe] = [loadCakeRecipe(), loadCurryRecipe(), loadSaladRecipe()]
    @Previewable @State var discardedRecipes: [Recipe] = []
    SavedRecipesView(savedRecipes: $savedRecipes, discardedRecipes: $discardedRecipes)
}
