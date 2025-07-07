//
//  FeatureItem.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 7/5/25.
//

import SwiftUI

struct FeatureItem: View {
    let systemName: String
    let title: String
    let color: Color
    let delay: Double
    @State private var isAnimating = false
    //struct to create the little icons and text
    var body: some View {
        VStack {
            Image(systemName: systemName)
                .font(.system(size: 30))
                .foregroundColor(color)
                .symbolEffect(.bounce, value: isAnimating)

            Text(title)
                .font(.caption)
                .bold()
                .foregroundColor(.secondary)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    FeatureItem(
        systemName: "hand.tap",
        title: "Simple",
        color: .blue,
        delay: 1.0
    )
}
