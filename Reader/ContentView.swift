
//  ContentView.swift
//  Reader
//  Created by Joanne on 3/3/25.


import SwiftUI
import CloudKit

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            
            NavigationStack {
                CurrentlyReadingView()
                    .navigationTitle("Currently Reading")
            }
            .tabItem {
                Label("Reading", systemImage: "book.fill")
            }
            
            NavigationStack {
                WantToReadView()
                    .navigationTitle("Want to Read")
            }
            .tabItem {
                Label("Want to Read", systemImage: "bookmark.fill")
            }
            
            NavigationStack {
                ProfileView()
                    .navigationTitle("Profile")
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
    }
}

struct ProfileView: View {
    var body: some View {
        List {
            Section("Reading Statistics") {
                StatRow(title: "Books Read", value: "0")
                StatRow(title: "Currently Reading", value: "0")
                StatRow(title: "Want to Read", value: "0")
            }
            
            Section("Account") {
                NavigationLink {
                    SettingsView()
                } label: {
                    Label("Settings", systemImage: "gear")
                }
                
                NavigationLink {
                    AboutView()
                } label: {
                    Label("About", systemImage: "info.circle")
                }
            }
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct SettingsView: View {
    @AppStorage("darkMode") private var darkMode = false
    @AppStorage("notificationsEnabled") private var notificationsEnabled = true
    
    var body: some View {
        List {
            Section("Appearance") {
                Toggle("Dark Mode", isOn: $darkMode)
            }
            
            Section("Notifications") {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
            }
        }
        .navigationTitle("Settings")
    }
}

struct AboutView: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 20) {
                    Image(systemName: "books.vertical.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text("Reader App")
                        .font(.title)
                        .bold()
                    
                    Text("Version 1.0.0")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
            
            Section("Developer") {
                LabeledContent("Created by", value: "Joana")
            }
        }
        .navigationTitle("About")
    }
}

#Preview {
    ContentView()
}
