/// HomeView serves as the main interface for the Reader app
/// Responsibilities:
/// - Manages book search functionality
/// - Displays search results in a scrollable list
/// - Provides quick access to reading lists
/// - Handles error and success states
/// - Created by: Joana


import SwiftUI

struct HomeView: View {
    // MARK: - State Management
    /// Tracks the current search input from user
    @State private var searchText = ""
    /// Stores the list of books returned from search
    @State private var books: [Book] = []
    /// Controls loading state during API calls
    @State private var isLoading = false
    /// Stores error messages for display
    @State private var errorMessage: String?
    /// Controls visibility of error alert
    @State private var showingError = false
    /// Controls visibility of success alert
    @State private var showingSuccess = false
    /// Triggers UI refresh when books are added
    @State private var refreshTrigger = false
    
    // MARK: - View Body
    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Search Interface
                SearchBar(text: $searchText, onCommit: performSearch)
                    .padding()
                
                // MARK: - Dynamic Content Area
                ZStack {
                    if isLoading {
                        ProgressView("Searching...")
                    } else if !books.isEmpty {
                        List(books) { book in
                            BookRow(book: book,
                                  onCurrentlyReading: { addToCurrentlyReading(book) },
                                  onWantToRead: { addToWantToRead(book) }
                            )
                        }
                        .listStyle(PlainListStyle())
                        .id(refreshTrigger) // Force list refresh when books are added
                    } else if !searchText.isEmpty {
                        ContentUnavailableView("No Results",
                            systemImage: "magnifyingglass",
                            description: Text("Try searching for another book"))
                    } else {
                        ContentUnavailableView("Search Books",
                            systemImage: "book.circle",
                            description: Text("Enter a book title or author to begin"))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // MARK: - Quick Access Navigation
                VStack(spacing: 16) {
                    NavigationLink {
                        CurrentlyReadingView()
                    } label: {
                        QuickAccessButton(
                            title: "Currently Reading",
                            icon: "book.fill",
                            color: .blue
                        )
                    }
                    
                    NavigationLink {
                        WantToReadView()
                    } label: {
                        QuickAccessButton(
                            title: "Want to Read",
                            icon: "bookmark.fill",
                            color: .green
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Reader")
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "An unknown error occurred")
            }
            .alert("Success", isPresented: $showingSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Book added successfully!")
            }
        }
    }
    
    // MARK: - Book Management Methods
    private func addToCurrentlyReading(_ book: Book) {
        print("Attempting to add to Currently Reading: \(book.volumeInfo.title)")
        
        // Check if book is already in the list
        let currentBooks = Book.getLocalBooks(listType: .currentlyReading)
        if currentBooks.contains(where: { $0.id == book.id }) {
            errorMessage = "This book is already in your Currently Reading list"
            showingError = true
            print("Book already in Currently Reading list")
            return
        }
        
        // Remove from Want to Read if it exists there
        Book.removeFromLocal(book, listType: .wantToRead)
        
        // Save to Currently Reading
        Book.saveLocally(book, listType: .currentlyReading)
        
        // Update UI
        refreshTrigger.toggle()
        showingSuccess = true
        print("Successfully added to Currently Reading")
        
        // Debug: Verify storage
        let updatedBooks = Book.getLocalBooks(listType: .currentlyReading)
        print("Current number of books in Currently Reading: \(updatedBooks.count)")
    }
    
    private func addToWantToRead(_ book: Book) {
        print("Attempting to add to Want to Read: \(book.volumeInfo.title)")
        
        // Check if book is already in either list
        let wantToReadBooks = Book.getLocalBooks(listType: .wantToRead)
        if wantToReadBooks.contains(where: { $0.id == book.id }) {
            errorMessage = "This book is already in your Want to Read list"
            showingError = true
            print("Book already in Want to Read list")
            return
        }
        
        let currentlyReadingBooks = Book.getLocalBooks(listType: .currentlyReading)
        if currentlyReadingBooks.contains(where: { $0.id == book.id }) {
            errorMessage = "This book is already in your Currently Reading list"
            showingError = true
            print("Book already in Currently Reading list")
            return
        }
        
        // Save to Want to Read
        Book.saveLocally(book, listType: .wantToRead)
        
        // Update UI
        refreshTrigger.toggle()
        showingSuccess = true
        print("Successfully added to Want to Read")
        
        // Debug: Verify storage
        let updatedBooks = Book.getLocalBooks(listType: .wantToRead)
        print("Current number of books in Want to Read: \(updatedBooks.count)")
    }
    
    // MARK: - Search Implementation
    private func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        isLoading = true
        books = []
        
        Task {
            do {
                let url = "https://www.googleapis.com/books/v1/volumes?q=\(searchText.urlEncoded ?? "")"
                guard let searchURL = URL(string: url) else {
                    throw URLError(.badURL)
                }
                
                let (data, _) = try await URLSession.shared.data(from: searchURL)
                let results = try JSONDecoder().decode(BookResult.self, from: data)
                
                await MainActor.run {
                    books = results.items
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showingError = true
                    isLoading = false
                }
            }
        }
    }
}


// MARK: - Supporting Views
struct BookRow: View {
    let book: Book
    let onCurrentlyReading: () -> Void
    let onWantToRead: () -> Void
    
    @State private var isPressingCurrently = false
    @State private var isPressingWantTo = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // Book Cover Image
                if let imageURL = book.volumeInfo.imageLinks?.secureImageURL {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 60, height: 90)
                    .cornerRadius(6)
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 60, height: 90)
                        .cornerRadius(6)
                }
                
                // Book Details
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.volumeInfo.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(book.volumeInfo.authorDisplay)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let description = book.volumeInfo.description {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                    
                    // Action Buttons
                    HStack {
                        Spacer()
                        
                        // Currently Reading Button
                        Button {
                            print("Currently Reading button tapped")
                            onCurrentlyReading()
                        } label: {
                            HStack {
                                Text("Currently Reading")
                                Image(systemName: "plus.circle.fill")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(isPressingCurrently ? 0.95 : 1.0)
                        .font(.caption)
                        .foregroundColor(.blue)
                        
                        Spacer()
                        
                        // Want to Read Button
                        Button {
                            print("Want to Read button tapped")
                            onWantToRead()
                        } label: {
                            HStack {
                                Text("Want to Read")
                                Image(systemName: "plus.circle.fill")
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.green, lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(isPressingWantTo ? 0.95 : 1.0)
                        .font(.caption)
                        .foregroundColor(.green)
                    }
                    .padding(.top, 8)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct QuickAccessButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

// MARK: - Press Animation Extension
extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        self
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        onPress()
                    }
                    .onEnded { _ in
                        onRelease()
                    }
            )
    }
}

// MARK: - Preview Provider
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
