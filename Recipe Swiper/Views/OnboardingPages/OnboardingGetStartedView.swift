import SwiftUI

struct OnboardingGetStartedView: View {
    // This property wrapper links the variable to UserDefaults
    // using the key "isOnboarding".
    @AppStorage("isOnboarding") var isOnboarding: Bool?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("You're All Set!")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
           
            // TODO: Add an image here
            
            //
            Spacer()
            Button {
                isOnboarding = false
            } label: {
                Text("Let's Get Cooking!")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
        .padding(.bottom)
    }
}

#Preview {
    OnboardingGetStartedView()
}
