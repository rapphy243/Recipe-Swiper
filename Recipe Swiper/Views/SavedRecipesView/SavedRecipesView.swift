//
//  SavedRecipesView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftData
import SwiftUI

struct SavedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var sortBy: SortBy = .name
    @State private var filter: RecipeFilter = .all
    @State private var recipeList: [RecipeModel] = []
    var body: some View {
        NavigationStack {
            List {
                ForEach(recipeList, id: \.self) { recipe in
                    RecipeListItem(recipe: recipe)
                }
            }
            .navigationTitle("Saved Recipes")
            .toolbar {
                RecipeListToolBar(sortBy: $sortBy, filter: $filter)
            }
            .overlay {
                if recipeList.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label(
                                "No saved recipes",
                                systemImage: "book.closed.fill"
                            )
                        },
                        description: {
                            Text(
                                "Start saving recipes by swiping right on them in the Home page."
                            )
                        }
                    )
                }
            }
        }
        .onAppear {
            fetchRecipes()
        }
        .onChange(of: sortBy) { _, _ in
            fetchRecipes()
        }
        .onChange(of: filter) { _, _ in
            fetchRecipes()
        }
    }
    
    private func fetchRecipes() {
        let descriptor = sortBy.sortDescriptor
        let predicate = filter.predicate

        let fetchDescriptor = FetchDescriptor<RecipeModel>(predicate: predicate, sortBy: [descriptor])
        do {
            recipeList = try modelContext.fetch(fetchDescriptor)
        } catch {
            recipeList = []
        }
    }
}

enum SortBy {
    case newest, oldest, name, rating

    var sortDescriptor: SortDescriptor<RecipeModel> {
        switch self {
        case .newest:
            return SortDescriptor(\RecipeModel.dateModified, order: .reverse)
        case .oldest:
            return SortDescriptor(\RecipeModel.dateModified, order: .forward)
        case .name:
            return SortDescriptor(\RecipeModel.title)
        case .rating:
            return SortDescriptor(\RecipeModel.rating, order: .reverse)
        }
    }
}

enum RecipeFilter {
    case all, hasRating

    var predicate: Predicate<RecipeModel>? {
        switch self {
        case .all:
            return nil // No filter
        case .hasRating:
            return #Predicate { $0.rating > 0 }
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
