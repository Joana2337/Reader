
/// ContentView.swift
/// Reader
/// Created by Joanne on 3/3/25.
/// Refrences:
/// Google Books API: https://developers.google.com/books/docs/v1/getting_started
/// Async/Await for API Calls: https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html
/// Swift's Codable Protocols: https://developer.apple.com/documentation/swift/codable
/// URLSession: https://developer.apple.com/documentation/foundation/urlsession

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    init() {
           /// Configure tab bar appearance for dark mode
           let tabBarAppearance = UITabBarAppearance()
           tabBarAppearance.configureWithDefaultBackground()
           tabBarAppearance.backgroundColor = UIColor.black
           
           UITabBar.appearance().standardAppearance = tabBarAppearance
           if #available(iOS 15.0, *) {
               UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
           }
       }
    
    var body: some View {
        TabView {
            // MARK: - Search Tab
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            // MARK: - Currently Reading Tab
            NavigationStack {
                CurrentlyReadingView()
                    .navigationTitle("Currently Reading")
            }
            .tabItem {
                Label("Reading", systemImage: "book.fill")
            }
            
            // MARK: - Want to Read Tab
            NavigationStack {
                WantToReadView()
                    .navigationTitle("Want to Read")
            }
            .tabItem {
                Label("Want to Read", systemImage: "bookmark.fill")
            }
            
        }
        .environment(\.managedObjectContext, viewContext)
        .accentColor(.blue) // Customize selected tab color
        
    }
}


// MARK: - Preview
//#Preview {
//    ContentView()
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
