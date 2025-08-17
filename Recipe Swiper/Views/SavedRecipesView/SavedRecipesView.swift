//
//  SavedRecipesView.swift
//  Recipe Swiper
//
//  Created by Tyler Berlin on 6/22/25.
//

import SwiftData
import SwiftUI

@Observable class SavedRecipesViewModel {
    var sortBy: SortBy
    var filter: RecipeFilter
    var recipeList: [RecipeModel]
    var selection: Set<RecipeModel>

    init() {
        self.sortBy = .newest
        self.filter = .all
        self.recipeList = []
        self.selection = []
    }
}

struct SavedRecipesView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    @Binding var SearchText: String
    @State private var model = SavedRecipesViewModel()
    private var filteredRecipes: [RecipeModel] {
        guard !SearchText.isEmpty else {
            return model.recipeList
        }
        return model.recipeList.filter {
            $0.title.lowercased().contains(SearchText.lowercased())
        }
    }

    var body: some View {
        NavigationStack {
            List(selection: $model.selection) {
                ForEach(filteredRecipes, id: \.self) { recipe in
                    NavigationLink(destination: RecipePageView(recipe: recipe))
                    {
                        RecipeListItem(recipe: recipe)
                            .swipeActions(edge: .leading) {
                                Button {
                                    withAnimation {
                                        recipe.rating = 0
                                    }
                                } label: {
                                    Label(
                                        "Clear Rating",
                                        systemImage: "star.slash"
                                    )
                                }
                                .tint(.orange)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    modelContext.delete(recipe)
                                    fetchRecipes()
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                    }
                }
            }
            .navigationTitle("Saved Recipes")
            .toolbar {
                RecipeListToolBar(
                    model: model,
                    onDeleteSelected: deleteSelected
                )
            }
            .overlay {
                if model.recipeList.isEmpty {
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
        .onChange(of: model.sortBy) { _, _ in
            fetchRecipes()
        }
        .onChange(of: model.filter) { _, _ in
            fetchRecipes()
        }
    }

    private func deleteSelected() {
        guard !model.selection.isEmpty else { return }
        for recipe in model.selection {
            modelContext.delete(recipe)
        }
        model.selection.removeAll()
        fetchRecipes()
    }

    private func fetchRecipes() {
        let descriptor = model.sortBy.sortDescriptor
        let predicate = model.filter.predicate

        let fetchDescriptor = FetchDescriptor<RecipeModel>(
            predicate: predicate,
            sortBy: [descriptor]
        )
        do {
            model.recipeList = try modelContext.fetch(fetchDescriptor)
        } catch {
            model.recipeList = []
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
            return nil  // No filter
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

    return SavedRecipesView(SearchText: .constant(""))
        .modelContainer(container)
}
