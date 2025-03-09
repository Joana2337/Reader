//
//  ReaderApp.swift
//  Reader
//  Created by Joanne on 3/3/25.
//

import SwiftUI
import CloudKit

@main
struct ReaderApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
