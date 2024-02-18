import SwiftUI

struct ConversationCard: View {
    
    var conversation: Conversation
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var deleteAction: () -> Void
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .foregroundColor(colorScheme == .dark ? Color(red: 0.27, green: 0.27, blue: 0.29) : Color.black)
                .cornerRadius(30)
            
            VStack(alignment: .leading, spacing: 7) {
                Text(conversation.title)
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                
                HStack {
                    Text("No. of participants: ")
                        .fontWeight(.semibold)
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                    Text("\(conversation.participantNames.count)")
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                }
                
                HStack {
                    Text("Total time: ")
                        .fontWeight(.semibold)
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                    Text(formatDuration(conversation.totalDuration))
                        .font(.title3)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                }
                
                Text("Note:")
                    .fontWeight(.semibold)
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                
                Text(conversation.notes)
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
                    .mask(
                        LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .top, endPoint: .bottom)
                    )
            }
            .padding(20)
            
            Menu {
                Button("Delete", role: .destructive, action: deleteAction)
            } label: {
                Label("", systemImage: "ellipsis.circle")
                    .font(.title)
            }
            .offset(x: UIScreen.main.bounds.width > 768 ? 340 : 240, y: 10) // Adjust for screen size
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? "N/A"
    }
}
