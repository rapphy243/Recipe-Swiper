//
//  SavedRecipesView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftData
import SwiftUI

struct SavedRecipesView: View {
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

    var savedRecipes: [RecipeModel] {
        try! modelContext.fetch(
            FetchDescriptor<RecipeModel>(
                predicate: #Predicate<RecipeModel> { !$0.isDiscarded },
                sortBy: [sortOrder.sortDescriptor]
            )
        )
    }

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
                            listDetails(recipe: recipe)
                        } else {
                            NavigationLink(
                                destination: FullRecipe(recipe: recipe)
                            ) {
                                listDetails(recipe: recipe)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !savedRecipes.isEmpty {
                        Menu {
                            Button("Most Recent") {
                                sortOrder = .dateDesc
                            }
                            Button("Oldest First") {
                                sortOrder = .dateAsc
                            }
                            Button("By Title") {
                                sortOrder = .title
                            }
                            Button("By Rating") {
                                sortOrder = .rating
                            }
                            Divider()
                            Button(isEditing ? "Done" : "Edit") {
                                withAnimation {
                                    isEditing.toggle()
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .overlay {
                if savedRecipes.isEmpty {
                    ContentUnavailableView(
                        label: {
                            Label(
                                "No saved recipes yet",
                                systemImage: "list.bullet.rectangle.portrait"
                            )
                        },
                        description: {
                            Text(
                                "Start saving recipes by swiping right on them in the Home feed."
                            )
                        }
                    )
                }
            }
        }
    }
}

struct listDetails: View {
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
                if recipe.rating > 0 {
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(
                                systemName: star <= Int(recipe.rating)
                                    ? "star.fill" : "star"
                            )
                            .foregroundColor(.yellow)
                            .font(.caption)
                        }
                    }
                }
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
    let recipe1 = RecipeModel(from: loadCakeRecipe(), isDiscarded: false)
    let recipe2 = RecipeModel(from: loadCurryRecipe(), isDiscarded: false)
    let recipe3 = RecipeModel(from: loadSaladRecipe(), isDiscarded: false)
    container.mainContext.insert(recipe1)
    container.mainContext.insert(recipe2)
    container.mainContext.insert(recipe3)

    return SavedRecipesView()
        .modelContainer(container)
}
