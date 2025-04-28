//
//  Stars.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/27/25.
//

import SwiftUI

struct RatingComponent: View {
    @Binding var rating: Int?
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Rate this Recipe")
                .font(.title2)
                .bold()
                .padding(.top)
            HStack {
                ForEach(1...5, id: \.self) { star in
                    Image(
                        systemName: star <= (rating ?? 0) ? "star.fill" : "star"
                    )
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = star
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var recipe = loadCakeRecipe()
    RatingComponent(rating: $recipe.rating)
}
