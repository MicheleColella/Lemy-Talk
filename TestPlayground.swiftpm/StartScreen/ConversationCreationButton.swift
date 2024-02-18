import SwiftUI

struct ConversationCreationButton: View {
    @Binding var isPulsating: Bool
    
    var body: some View {
        ZStack {
            agreementImage
            pulsatingCircle
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                self.isPulsating = true
            }
        }
    }
    
    private var pulsatingCircle: some View {
        Circle()
            .stroke(lineWidth: isLargeScreen ? 35.50 : 25.50)
            .frame(width: isLargeScreen ? 370 : 249, height: isLargeScreen ? 370 : 249)
            .scaleEffect(isPulsating ? 1 : 0.9)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 50)
    }
    
    private var agreementImage: some View {
        Image("Agreement")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: isLargeScreen ? 360 : 240, height: isLargeScreen ? 360 : 240)
            .scaleEffect(isPulsating ? 1 : 0.9)
    }
    
    private var isLargeScreen: Bool {
        UIScreen.main.bounds.width > 768
    }
}
