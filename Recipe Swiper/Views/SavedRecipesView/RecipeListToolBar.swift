//
//  RecipeListToolBar.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 7/23/25.
//

import SwiftData
import SwiftUI

struct RecipeListToolBar: ToolbarContent {
    @Binding var sortBy: SortBy
    @Binding var filter: RecipeFilter
    @Binding var selection: Set<RecipeModel>
    var onDeleteSelected: () -> Void
    @Environment(\.editMode) private var editMode
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            if (editMode?.wrappedValue.isEditing ?? false) {
                Button(role: .destructive) {
                    onDeleteSelected()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(selection.isEmpty)
            }
        }
        ToolbarItemGroup(placement: .topBarTrailing) {
            Menu {
                // Toggle Edit Mode inside the menu
                Button(action: {
                    withAnimation {
                        if editMode?.wrappedValue.isEditing == true {
                            editMode?.wrappedValue = .inactive
                            selection.removeAll()
                        } else {
                            editMode?.wrappedValue = .active
                        }
                    }
                }) {
                    Label(editMode?.wrappedValue.isEditing == true ? "Done" : "Edit", systemImage: editMode?.wrappedValue.isEditing == true ? "checkmark.circle" : "pencil")
                }
                Divider()
                Picker(
                    selection: $sortBy,
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
                    selection: $filter,
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
                Image(systemName: "ellipsis")
            }
        }
    }
}
