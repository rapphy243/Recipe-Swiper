//
//  QuoteView.swift
//  Recipe Swiper
//
//  Created by Tyler Berlin on 4/23/25.
//

import SwiftUI

struct QuoteCard: View {
    static let quotes = [
        "Cooking is like love. It should be entered into with abandon or not at all. – Harriet Van Horne",
        "Food is symbolic of love when words are inadequate. – Alan D. Wolfelt",
        "One cannot think well, love well, sleep well, if one has not dined well. – Virginia Woolf",
        "People who love to eat are always the best people. – Julia Child",
        "Food brings people together on many different levels. It’s nourishment of the soul and body; it’s truly love. – Giada De Laurentiis",
        "Eating is a necessity, but cooking is an art. – Unknown",
        "Food is our common ground, a universal experience. – James Beard",
        "The secret of success in life is to eat what you like and let the food fight it out inside. – Mark Twain",
        "Life is uncertain. Eat dessert first. – Ernestine Ulmer",
        "The only time to eat diet food is while you’re waiting for the steak to cook. – Julia Child",
        "Food is the ingredient that binds us together. – Unknown",
        "First, we eat. Then, we do everything else. – M.F.K. Fisher",
        "Good food is the foundation of genuine happiness. – Auguste Escoffier",
        "The only thing I like better than talking about food is eating. – John Walters",
        "There is no sincerer love than the love of food. – George Bernard Shaw",
        "Laughter is brightest in the place where the food is. – Irish Proverb",
        "Food is not just eating energy. It’s an experience. – Guy Fieri",
        "A recipe has no soul. You, as the cook, must bring soul to the recipe. – Thomas Keller",
        "I cook with wine, sometimes I even add it to the food. – W.C. Fields",
        "Food is art, and you are the artist. – Unknown",
        "The only thing better than talking about food is eating it. – John Walters",
        "Life is too short to eat boring food. – Unknown",
        "Food is the most primitive form of comfort. – Sheila Graham",
        "To eat is a necessity, but to eat intelligently is an art. – François de La Rochefoucauld",
        "Good food, good company, great memories. – Unknown",
        "Food is the ultimate equalizer. It brings people together from all walks of life. – Unknown",
        "The fondest memories are made when gathered around the table. – Unknown",
        "The only thing better than a friend is a friend with chocolate. – Linda Grayson",
        "Life is short. Eat dessert first. – Jacques Torres",
        "Food is love made visible. – Sarah Ban Breathnach",
        "Cooking is all about people. Food is maybe the only universal thing that really has the power to bring everyone together. No matter what culture, everywhere around the world, people get together to eat. – Guy Fieri",
        "The secret ingredient is always love. – Unknown",
    ]
    @State private var quoteIndex = Int.random(
        in: 0..<QuoteCard.quotes.count
    )
    @Binding var refreshQuote: Bool
    
    var body: some View {
        Card {
            Text(QuoteCard.quotes[quoteIndex])
                .minimumScaleFactor(0.5)
                .font(.title2)
                .lineLimit(4)
                .containerRelativeFrame(
                    .vertical,
                    { height, _ in
                        return height * 0.1
                    }
                )
                .containerRelativeFrame(
                    .horizontal,
                    { width, _ in
                        return width * 0.87
                    }
                )
        }
        .onChange(of: refreshQuote) {
            quoteIndex = Int.random(
                in: 0..<QuoteCard.quotes.count)
        }
    }
}
#Preview {
    QuoteCard(refreshQuote: .constant(false))
}
