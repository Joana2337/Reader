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
    
    // MARK: - View Body
    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Search Interface
                /// SearchBar component handles user input and search triggering
                SearchBar(text: $searchText, onCommit: performSearch)
                    .padding()
                
                // MARK: - Dynamic Content Area
                /// ZStack manages different view states (loading/results/empty)
                ZStack {
                    if isLoading {
                        // Loading State
                        ProgressView("Searching...")
                    } else if !books.isEmpty {
                        // Search Results Display
                        List(books) { book in
                            BookRow(book: book,
                                  onCurrentlyReading: { addToCurrentlyReading(book) },
                                  onWantToRead: { addToWantToRead(book) }
                            )
                        }
                        .listStyle(PlainListStyle())
                    } else if !searchText.isEmpty {
                        // No Results State
                        ContentUnavailableView("No Results",
                            systemImage: "magnifyingglass",
                            description: Text("Try searching for another book"))
                    } else {
                        // Initial State
                        ContentUnavailableView("Search Books",
                            systemImage: "book.circle",
                            description: Text("Enter a book title or author to begin"))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // MARK: - Quick Access Navigation
                /// Bottom navigation section for accessing reading lists
                VStack(spacing: 16) {
                    // Currently Reading Section
                    NavigationLink {
                        CurrentlyReadingView()
                    } label: {
                        QuickAccessButton(
                            title: "Currently Reading",
                            icon: "book.fill",
                            color: .blue
                        )
                    }
                    
                    // TODO: Implement WantToReadView
                    // Want to Read Section - Temporarily disabled
                    
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
            // MARK: - Alert Handlers
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
    /// Adds a book to Currently Reading list
    /// - Parameter book: The book to be added
    private func addToCurrentlyReading(_ book: Book) {
        // Check if book is already in the list
        let currentBooks = Book.getLocalBooks(listType: .currentlyReading)
        if currentBooks.contains(where: { $0.id == book.id }) {
            errorMessage = "This book is already in your Currently Reading list"
            showingError = true
            return
        }
        
        // Save the book
        Book.saveLocally(book, listType: .currentlyReading)
        showingSuccess = true
    }
    
    /// Adds a book to Want to Read list
    /// - Parameter book: The book to be added
    private func addToWantToRead(_ book: Book) {
        Book.saveLocally(book, listType: .wantToRead)
        showingSuccess = true
    }
    
    // MARK: - Search Implementation
    /// Performs book search using Google Books API
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
/// Displays a single book in the search results list with action buttons
struct BookRow: View {
    /// The book to display
    let book: Book
    /// Callback when user wants to add to Currently Reading
    let onCurrentlyReading: () -> Void
    /// Callback when user wants to add to Want to Read
    let onWantToRead: () -> Void
    
    // Add state for button press animation
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
                    // Placeholder for books without covers
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
                        Button(action: onCurrentlyReading) {
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
                        .scaleEffect(isPressingCurrently ? 0.95 : 1.0)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .pressEvents {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                isPressingCurrently = true
                            }
                        } onRelease: {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                isPressingCurrently = false
                            }
                        }
                        
                        Spacer()
                        
                        // Want to Read Button (Temporarily visible but will be implemented later)
                        Button(action: onWantToRead) {
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
                        .scaleEffect(isPressingWantTo ? 0.95 : 1.0)
                        .font(.caption)
                        .foregroundColor(.green)
                        .pressEvents {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                isPressingWantTo = true
                            }
                        } onRelease: {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                isPressingWantTo = false
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

/// Quick access button for navigation
struct QuickAccessButton: View {
    /// The title of the button
    let title: String
    /// SF Symbol name for the icon
    let icon: String
    /// Color for the icon
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
    /// Adds press animation to a view
    /// - Parameters:
    ///   - onPress: Callback when press begins
    ///   - onRelease: Callback when press ends
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

//things to fix..currently reading and want to read needs to be an add button. All what there're to do is let me either add a book up to either currently reading or want to read. search bar does list books alright but clicking on it does nothing - its supposed to show authors info and book info if I click on them.
//things to fix..currently reading and want to read needs to be an add button. All what there're to do is let me either add a book up to either currently reading or want to read. search bar does list books alright but clicking on it does nothing - its supposed to show authors info and book info if I click on them.
