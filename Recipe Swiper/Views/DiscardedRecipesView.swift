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
    @State private var sortOrder = SortOrder.dateDesc
    @State private var isEditing: Bool = false

    enum SortOrder {
        case dateDesc, dateAsc, title, rating

        var sortDescriptor: SortDescriptor<RecipeModel> {
            switch self {
            case .dateDesc:
                return SortDescriptor(
                    \RecipeModel.dateModified,
                    order: .reverse
                )
            case .dateAsc:
                return SortDescriptor(\RecipeModel.dateModified)
            case .title:
                return SortDescriptor(\RecipeModel.title)
            case .rating:
                return SortDescriptor(\RecipeModel.rating, order: .reverse)
            }
        }
    }

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
                    HStack {
                        if isEditing {
                            withAnimation {
                                Button(action: {
                                    recipe.isDiscarded = false
                                }) {
                                    Image(systemName: "plus.circle")
                                        .foregroundColor(.green)
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
                        //                        VStack(alignment: .leading) {
                        //                            Text(recipe.title)
                        //                                .font(.headline)
                        //                            if recipe.rating > 0 {
                        //                                HStack {
                        //                                    ForEach(1...5, id: \.self) { star in
                        //                                        Image(systemName: star <= recipe.rating ? "star.fill" : "star")
                        //                                            .foregroundColor(.yellow)
                        //                                            .font(.caption)
                        //                                    }
                        //                                }
                        //                            }
                        //                        }
                        Spacer()
                    }
                }
            }
            .toolbar {

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
                            Text("Recipes you swipe left on will appear here.")
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
