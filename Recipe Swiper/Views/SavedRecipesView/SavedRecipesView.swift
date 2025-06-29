//
//  SavedRecipesView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/22/25.
//

import SwiftUI

struct SavedRecipesView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("Saved Recipes")
            }
                .navigationTitle("Saved Recipes")
        }
    }
}

#Preview {
    SavedRecipesView()
}
