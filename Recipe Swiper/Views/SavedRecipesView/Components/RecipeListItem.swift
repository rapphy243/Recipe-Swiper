//
//  RecipeListItem.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/28/25.
//

import SwiftUI

struct RecipeListItem: View {
    var body: some View {
        HStack {
            Image(systemName: "book.fill")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipped()
                .cornerRadius(10)
        }
    }
}

#Preview {
    RecipeListItem()
}
