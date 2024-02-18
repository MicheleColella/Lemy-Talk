//
//  File.swift
//  
//
//  Created by Michele Colella on 16/02/24.
//

import Foundation

extension ContentView{
    public func loadConversations() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            
            var loadedConversations = [Conversation]()
            for url in fileURLs where url.pathExtension == "json" {
                do {
                    let data = try Data(contentsOf: url)
                    let conversation = try JSONDecoder().decode(Conversation.self, from: data)
                    loadedConversations.append(conversation)
                } catch {
                    //print("Error decoding conversation: \(error)")
                }
            }
            
            self.conversations = loadedConversations.sorted(by: { $0.lastUpdated > $1.lastUpdated })
        } catch {
            //print("Error loading conversations: \(error)")
        }
    }
    
    
    public func deleteConversation(at index: Int) {
        let conversationToDelete = conversations[index]
        conversations.remove(at: index)
        
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
           let fileName = conversationToDelete.fileName {
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                    //print("Conversation successfully deleted.")
                } catch {
                    //print("Error deleting conversation: \(error)")
                }
            } else {
                //print("File not found. Check the path and file name.")
            }
        }
    }
}
