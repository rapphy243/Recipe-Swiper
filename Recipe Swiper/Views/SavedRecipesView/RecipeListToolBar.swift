//
//  RecipeListToolBar.swift
//  Recipe Swiper
//
//  Created by Snack Swipe Team (Zane, Tyler, Rapphy) on 7/23/25.
//

import SwiftData
import SwiftUI

struct RecipeListToolBar: ToolbarContent {
    @Bindable var model: SavedRecipesViewModel
    var onDeleteSelected: () -> Void
    @Environment(\.editMode) private var editMode
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            if editMode?.wrappedValue.isEditing ?? false {
                Button(role: .destructive) {
                    onDeleteSelected()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(model.selection.isEmpty)
            }
        }
        if editMode?.wrappedValue.isEditing == true {
            ToolbarItemGroup(placement: .confirmationAction) {
                Button(
                    action: {
                        withAnimation {
                            editMode?.wrappedValue = .inactive
                            model.selection.removeAll()
                        }
                    },
                    label: {
                        Label("Done", systemImage: "checkmark")
                    }
                )
            }
        } else {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Menu {
                    Button(
                        action: {
                            withAnimation {
                                editMode?.wrappedValue = .active
                            }
                        },
                        label: {
                            Label("Select", systemImage: "pencil")
                        }
                    )
                    Divider()
                    Picker(
                        selection: $model.sortBy,
                        content: {
                            Text("Newest")
                                .tag(SortBy.newest)
                            Text("Oldest")
                                .tag(SortBy.oldest)
                            Text("Name")
                                .tag(SortBy.name)
                            Text("Rating")
                                .tag(SortBy.rating)
                        },
                        label: {
                            Label(
                                "Sort by",
                                systemImage: "line.3.horizontal.decrease"
                            )
                        }
                    )
                    .pickerStyle(.menu)
                    Picker(
                        selection: $model.filter,
                        content: {
                            Text("All Recipes")
                                .tag(RecipeFilter.all)
                            Text("Has Rating")
                                .tag(RecipeFilter.hasRating)
                        },
                        label: {
                            Label("Filter by", systemImage: "list.bullet")
                        }
                    )
                    .pickerStyle(.menu)

                } label: {
                    Label("List Options", systemImage: "ellipsis")
                }
            }
        }
    }
}
