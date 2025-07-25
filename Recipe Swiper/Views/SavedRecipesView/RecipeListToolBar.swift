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

    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Menu {
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

