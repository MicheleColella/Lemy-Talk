//ContentView
import CoreFoundation
import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isPulsating = false
    @State public var conversations: [Conversation] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                settingsAndCalendarHeader
                Spacer()
                startConversationText
                startConversationButton
                recentConversationsHeader
                conversationsScrollView
            }
            .onAppear { loadConversations() }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var settingsAndCalendarHeader: some View {
        HStack {
            settingsNavigationLink
            Spacer()
            calendarImage
        }
        .padding(.bottom, 10)
    }
    
    private var settingsNavigationLink: some View {
        NavigationLink {
            SettingsView()
        } label: {
            Image(systemName: "calendar")
                .font(.system(size: isLargeScreen ? 60 : 40))
                .padding(.leading)
                .frame(height: 40)
        }
    }
    
    private var calendarImage: some View {
        Image(systemName: "calendar")
            .font(.system(size: isLargeScreen ? 60 : 40))
            .padding(.trailing)
            .frame(height: 40)
    }
    
    private var startConversationText: some View {
        Text("Start conversation")
            .font(.system(size: isLargeScreen ? 50 : 30).weight(.bold))
            .offset(y: -30)
    }
    
    private var startConversationButton: some View {
        NavigationLink {
            ConversationCreation()
        } label: {
            ConversationCreationButton(isPulsating: $isPulsating)
        }
    }
    
    private var recentConversationsHeader: some View {
        HStack(alignment: .center) {
            Text("Recent:")
                .font(.system(size: isLargeScreen ? 40 : 25).weight(.bold))
                .padding(.leading)
            Spacer()
        }
    }
    
    private var conversationsScrollView: some View {
        ScrollView(.horizontal) {
            HStack {
                if conversations.isEmpty {
                    emptyConversationRectangle
                } else {
                    ForEach(Array(conversations.enumerated()), id: \.element) { index, conversation in
                        ConversationCard(conversation: conversation, deleteAction: { deleteConversation(at: index) })
                            .frame(width: rectangleWidth, height: rectangleHeight)
                    }
                }
            }
            .padding()
        }
    }
    
    private var emptyConversationRectangle: some View {
        Rectangle()
            .foregroundColor(.gray)
            .frame(width: rectangleWidth, height: rectangleHeight)
            .cornerRadius(30)
            .overlay(Text("No conversation available").foregroundColor(.white))
    }
    
    private var isLargeScreen: Bool {
        UIScreen.main.bounds.width > 768
    }
    
    private var rectangleWidth: CGFloat {
        isLargeScreen ? 400 : 288
    }
    
    private var rectangleHeight: CGFloat {
        UIScreen.main.bounds.height > 1024 ? 400 : 279
    }
}
