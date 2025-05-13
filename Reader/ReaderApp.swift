
//  ReaderApp.swift
//  Reader
//  Created by Joanne on 3/3/25.

import SwiftUI

@main
struct ReaderApp: App {
    // Initialize persistence controller
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
