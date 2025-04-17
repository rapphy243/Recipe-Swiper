//
//  MainView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 4/11/25.
//

import SwiftUI

struct MainView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    @Binding var savedRecipes: [String]
    @State private var cardOffset: CGSize = .zero
    @State private var cardRotation: Double = 0
    @State private var cardIndex: Int = 0

    let recipes = ["Spaghetti", "Sushi", "Tacos", "Pancakes", "Salad"]

    var body: some View {
        NavigationStack {
            VStack {
                if cardIndex < recipes.count {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .shadow(radius: 4)
                            .frame(width: 300, height: 400)
                            .overlay(
                                Text(recipes[cardIndex])
                                    .font(.title)
                                    .foregroundColor(.black)
                            )
                            .offset(cardOffset)
                            .rotationEffect(.degrees(cardRotation))
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        cardOffset = value.translation
                                        cardRotation = Double(value.translation.width / 20)
                                    }
                                    .onEnded { value in
                                        if abs(value.translation.width) > 100 {
                                            if value.translation.width > 0 {
                                                savedRecipes.append(recipes[cardIndex])
                                            }
                                            withAnimation {
                                                cardOffset = CGSize(width: value.translation.width > 0 ? 500 : -500, height: 0)
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                cardIndex += 1
                                                cardOffset = .zero
                                                cardRotation = 0
                                            }
                                        } else {
                                            withAnimation {
                                                cardOffset = .zero
                                                cardRotation = 0
                                            }
                                        }
                                    }
                            )
                    }
                } else {
                    Text("No more recipes!")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("Restart Onboarding", systemImage: "gear") {
                            isOnboarding = true
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
    }
}

#Preview {
    MainView(savedRecipes: .constant([]))
}
