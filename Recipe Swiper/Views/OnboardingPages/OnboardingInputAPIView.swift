//
//  OnboardingInputAPIView.swift
//  Recipe Swiper
//
//  Created by Raphael Abano on 5/21/25.
//

import SwiftUI

struct OnboardingInputAPIView: View {
    @State private var apiKey: String = Secrets.apiKey == "No Build API Key" ? "" : Secrets.apiKey
    @Binding var selectedTab: Int
    @Binding var showFinalTab: Bool
    let spoonacularDashboardURL = URL(
        string: "https://spoonacular.com/food-api/console#Profile"
    )!
    var body: some View {
            VStack(spacing: 25) {
                Spacer().frame(height: 20)

                Image(
                    systemName: "key.fill"
                )
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.orange)

                Text("Spoonacular API Key")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text(
                    "To fetch delicious recipes, Recipe Swiper needs access to the Spoonacular API. Please enter your API key below."
                )
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

                // Instructions Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("How to get your API Key:")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Step(
                        number: "1",
                        text: "Go to the Spoonacular API Dashboard."
                    )
                    Link(
                        destination: spoonacularDashboardURL,
                        label: {
                            Text(spoonacularDashboardURL.absoluteString)
                                .font(.callout)
                                .multilineTextAlignment(.leading)
                        }
                    )
                    .padding(.leading, 30) // Indent the link

                    Step(
                        number: "2",
                        text: "Sign up for a free account."
                    )
                    Step(
                        number: "3",
                        text: "Once logged in, you'll find your API Key under \"Profile & API Key\"."
                    )
                    Step(
                        number: "4",
                        text: "Copy the API Key and paste it into the field below."
                    )
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // API Key Input Field
                TextField("Paste your API Key here", text: $apiKey)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(
                        .oneTimeCode
                    )

                Button(action: {
                    Secrets.setApiKey(apiKey)
                    showFinalTab = true
                    selectedTab = 4
                }) {
                    Text("Save & Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            apiKey
                                .trimmingCharacters(
                                    in: .whitespacesAndNewlines
                                ).isEmpty ? Color.gray : Color.orange
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(
                    apiKey
                        .trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                )

                Spacer()
            }
            .padding(.bottom, 20)
        }
}

//Instruction steps
struct Step: View {
    let number: String
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(number).")
                .fontWeight(.medium)
            Text(text)
                .font(.callout)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    OnboardingInputAPIView(selectedTab: .constant(1), showFinalTab: .constant(false))
}
