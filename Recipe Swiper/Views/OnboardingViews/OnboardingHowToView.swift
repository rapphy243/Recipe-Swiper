//
//  OnboardingHowToView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 7/6/25.
//

import SwiftUI

struct OnboardingHowToView: View {
    @EnvironmentObject var model: OnboardingViewModel
    @State private var step = 0
    @State private var isNextButtonDisabled = false

    var instructionText: String {
        switch step {
        case 0:
            return
                "This is what a recipe looks like.\nLet's learn how to interact with it!"
        case 1:
            return
                "You can tap on the text next to the book to view the source!"
        case 2: return "Swipe left on the card to discard the recipe."
        case 3: return "Good! Now swipe right to save it to your cookbook!"
        default: return "Great Job!"
        }
    }

    private func handleSwipe(isLeft: Bool) async {
        if step > 1 {
            if step == 2 && isLeft {
                try! await Task.sleep(nanoseconds: 750_000_000)
                withAnimation {
                    step += 1
                }
            } else {
                if step == 3 && !isLeft {
                    try! await Task.sleep(nanoseconds: 750_000_000)
                    withAnimation {
                        step += 1
                    }
                    try! await Task.sleep(nanoseconds: 500_000_000)
                    withAnimation {
                        model.currentTab = 2
                    }
                }
            }
        }
    }

    var body: some View {
        VStack {
            Text(instructionText)
                .font(.headline)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding([.horizontal, .top])
                .id(step)
                .transition(.opacity)
            SwipableRecipeCard(
                recipe: model.recipe,
                onSwipeLeft: { Task { await handleSwipe(isLeft: true) } },
                onSwipeRight: { Task { await handleSwipe(isLeft: false) } }
            )
            if step < 2 {
                Button {
                    isNextButtonDisabled = true
                    withAnimation {
                        step += 1
                    }
                    Task {
                        try? await Task.sleep(nanoseconds: 500_000_000)
                        isNextButtonDisabled = false
                    }
                } label: {
                    HStack {
                        Text("Next")
                        Image(systemName: "arrow.right")
                    }
                }
                .buttonStyle(.borderedProminent)
                .clipShape(.rect(cornerRadius: 16))
                .sensoryFeedback(.impact, trigger: model.currentTab)
                .padding(.bottom)
                .disabled(isNextButtonDisabled)
            }
        }
    }
}

#Preview {
    OnboardingHowToView()
        .environmentObject(OnboardingViewModel())
}
