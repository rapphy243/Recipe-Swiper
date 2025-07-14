//
//  RecipeListItem.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/28/25.
//

import SwiftData
import SwiftUI

struct RecipeListItem: View {
    @State var recipe: RecipeModel
    var body: some View {
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
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .onAppear {
                        Task {
                            await recipe.getImage()
                        }
                    }
            }
            VStack(alignment: .leading) {
                Text(recipe.title)
                    .font(.headline)
                    .lineLimit(1)
                HStack {
                    SourceTag(source: recipe.sourceUrl ?? "")
                    ServingsTag(servings: recipe.servings)
                }
                .font(.caption)
                //TODO: Add rating component
                Spacer()
            }
            Spacer()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: RecipeModel.self,
        configurations: config
    )
    let recipe1 = RecipeModel(from: Recipe.Cake)
    container.mainContext.insert(recipe1)
    
    return SavedRecipesView()
        .modelContainer(container)
}

