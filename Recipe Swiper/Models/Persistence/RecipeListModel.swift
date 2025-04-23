//
//  RecipeListModel.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/23/25.
//
//  Generated with Claude 3.5 Sonnet

import Foundation
import SwiftData

@Model
final class RecipeList {
    var savedRecipes: [RecipeModel]
    var discardedRecipes: [RecipeModel]
    
    init() {
        savedRecipes = []
        discardedRecipes = []
    }
}
