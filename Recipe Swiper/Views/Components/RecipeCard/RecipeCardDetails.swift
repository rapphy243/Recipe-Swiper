//
//  RecipeCardDetails.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 6/24/25.
//

import SwiftUI

struct RecipeCardDetails: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                TimeTag(minutes: 45)
                ServingsTag(servings: 4)
            }
            
            HStack {
                SourceTag(source: URL(string: "https://www.allrecipes.com"))
            }
            
            HStack(spacing: 8) {
                CusineTags(
                    cuisines: ["Italian", "Mediterranean"],
                    showAll: false
                )
            }
            
            HStack(spacing: 8) {
                VegetarianTag()
                VeganTag()
                GlutenFreeTag()
                DairyFreeTag()
            }

        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
    }
}

#Preview {
    RecipeCardDetails()
}
