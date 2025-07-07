//
//  OnboardingInputAPI.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 7/6/25.
//

import SwiftUI

struct OnboardingInputAPI: View {
    @EnvironmentObject var model: OnboardingViewModel
    @State private var isAnimating = false
    @State private var apiKey: String =
        UserDefaults.standard.string(forKey: "apiKey") ?? ""
    @State private var showFootnote = false

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "key.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .symbolEffect(.bounce, value: isAnimating)
                .foregroundColor(.orange)

            VStack(spacing: 15) {
                Text("Spoonacular API Key")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .animation(
                        .easeOut(duration: 0.5).delay(0.2),
                        value: isAnimating
                    )

                Text(
                    "To fetch delicious recipes, Recipe Swiper needs access to the Spoonacular API. Please enter your API key below."
                )
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .opacity(isAnimating ? 1 : 0)
                .offset(y: isAnimating ? 0 : 20)
                .animation(
                    .easeOut(duration: 0.5).delay(0.4),
                    value: isAnimating
                )
                TextField("Paste your API Key here", text: $apiKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(
                        .oneTimeCode
                    )

                DisclosureGroup(
                    "How do I get an API key?",
                    isExpanded: $showFootnote
                ) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(
                            "1. Go to the [Spoonacular API Dashboard](https://spoonacular.com/food-api/console#Profile) and sign up for a free account."
                        )
                        Text(
                            "2. Once logged in, you'll find your API Key under \"Profile & API Key\""
                        )
                        Text(
                            "3. Tap \"Show API Key\" then copy and paste it into the field above."
                        )
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding([.top, .horizontal])
                }
            }
            .padding(.horizontal)

            Button {
                withAnimation {
                    model.currentTab = 4
                }
            } label: {
                HStack {
                    Text("Next")
                    Image(systemName: "arrow.right")
                }
            }
            .disabled(apiKey == "")
            .buttonStyle(.borderedProminent)
            .clipShape(.rect(cornerRadius: 16))
            .sensoryFeedback(.impact, trigger: model.currentTab)
            .padding(.bottom)
        }
        .padding(.top)
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    OnboardingInputAPI()
        .environmentObject(OnboardingViewModel())
}
