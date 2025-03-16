
//  ContentView.swift
//  Reader
//  Created by Joanne on 3/3/25.

import SwiftUI

/// Main view controller for the Reader app that manages the tab-based navigation
struct ContentView: View {
    var body: some View {
        // Main tab container that handles switching between different sections of the app
        TabView {
            // MARK: - Search Tab
            NavigationStack {
                // HomeView contains the book search functionality
                HomeView()
            }
            .tabItem {
                // Search icon and label for the first tab
                Label("Search", systemImage: "magnifyingglass")
            }
            
            // MARK: - Currently Reading Tab
            NavigationStack {
                // View for books that are currently being read
                CurrentlyReadingView()
                    .navigationTitle("Currently Reading")
            }
            .tabItem {
                // Book icon and label for the reading tab
                Label("Reading", systemImage: "book.fill")
            }
            
            // MARK: - Want to Read Tab
            NavigationStack {
                // View for books that user wants to read in the future
                WantToReadView()
                    .navigationTitle("Want to Read")
            }
            .tabItem {
                // Bookmark icon and label for the want to read tab
                Label("Want to Read", systemImage: "bookmark.fill")
            }
        }
    }
}

// MARK: - Preview
#Preview {
    ContentView()
}
