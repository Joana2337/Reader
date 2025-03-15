
/// CurrentlyReadingView displays and manages the user's active reading list
/// Allows users to track their reading progress for each book
/// - Created by: Joana
/// - Date: 2025-03-15
///

/// CurrentlyReadingView displays and manages the user's active reading list
/// Allows users to track their reading progress for each book
/// - Created by: Joana
/// -

import SwiftUI
struct CurrentlyReadingView: View {
    // MARK: - State Management
    /// Stores the list of books currently being read
    @State private var books: [Book] = []
    /// Maps book IDs to their reading progress (0.0 to 1.0)
    @State private var readingProgress: [String: Double] = [:]
    /// Controls the visibility of the progress update sheet
    @State private var showingProgressSheet = false
    /// Stores the book selected for progress update
    @State private var selectedBook: Book?
    /// Controls visibility of success alert
    @State private var showingAlert = false
    /// Stores alert message
    @State private var alertMessage = ""
    
    // MARK: - View Body
    var body: some View {
        Group {
            if books.isEmpty {
                // Display when no books are being read
                ContentUnavailableView(
                    "No Books Currently Reading",
                    systemImage: "book.closed",
                    description: Text("Books you add will appear here")
                )
            } else {
                // List of books being read with their progress
                List {
                    ForEach(books) { book in
                        CurrentlyReadingRow(
                            book: book,
                            progress: readingProgress[book.id] ?? 0,
                            onProgressTap: {
                                selectedBook = book
                                showingProgressSheet = true
                            }
                        )
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteBook(book)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Currently Reading")
        .onAppear {
            // Load data when view appears
            loadBooks()
            loadProgress()
        }
        .sheet(isPresented: $showingProgressSheet) {
            if let book = selectedBook {
                UpdateProgressView(
                    book: book,
                    currentProgress: readingProgress[book.id] ?? 0
                ) { newProgress in
                    updateProgress(for: book, progress: newProgress)
                    alertMessage = "Progress updated successfully!"
                    showingAlert = true
                }
            }
        }
        .alert("Reader", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Helper Methods
    /// Loads books from local storage marked as currently reading
    private func loadBooks() {
        books = Book.getLocalBooks(listType: .currentlyReading)
    }
    
    /// Loads saved reading progress for all books
    private func loadProgress() {
        if let savedProgress = UserDefaults.standard.dictionary(forKey: "reading_progress") as? [String: Double] {
            readingProgress = savedProgress
        }
    }
    
    /// Updates and saves the reading progress for a specific book
    /// - Parameters:
    ///   - book: The book to update progress for
    ///   - progress: The new progress value (0.0 to 1.0)
    private func updateProgress(for book: Book, progress: Double) {
        readingProgress[book.id] = progress
        UserDefaults.standard.set(readingProgress, forKey: "reading_progress")
    }
    
    /// Deletes a book from the Currently Reading list
    /// - Parameter book: The book to be deleted
    private func deleteBook(_ book: Book) {
        // Remove from local storage
        Book.removeFromLocal(book, listType: .currentlyReading)
        
        // Remove progress data
        readingProgress.removeValue(forKey: book.id)
        UserDefaults.standard.set(readingProgress, forKey: "reading_progress")
        
        // Update UI
        loadBooks()
        
        // Show confirmation
        alertMessage = "Book removed from Currently Reading"
        showingAlert = true
    }
}

// MARK: - Supporting Views
struct CurrentlyReadingRow: View {
    let book: Book
    let progress: Double
    let onProgressTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // Book Cover
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
                
                // Book Details and Progress
                VStack(alignment: .leading, spacing: 4) {
                    Text(book.volumeInfo.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(book.volumeInfo.authorDisplay)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 4) {
                        ProgressBar(progress: progress)
                            .frame(height: 6)
                            .cornerRadius(3)
                        
                        Button(action: onProgressTap) {
                            Text("\(Int(progress * 100))% Complete")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 4)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

/// Custom progress bar view
struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                
                // Progress indicator
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: geometry.size.width * progress)
            }
        }
    }
}

/// Sheet view for updating reading progress
struct UpdateProgressView: View {
    let book: Book
    let currentProgress: Double
    let onSave: (Double) -> Void
    
    @Environment(\.dismiss) private var dismiss
    @State private var progress: Double
    
    init(book: Book, currentProgress: Double, onSave: @escaping (Double) -> Void) {
        self.book = book
        self.currentProgress = currentProgress
        self.onSave = onSave
        _progress = State(initialValue: currentProgress)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text(book.volumeInfo.title)
                        .font(.headline)
                    Text(book.volumeInfo.authorDisplay)
                        .foregroundColor(.secondary)
                }
                
                Section("Reading Progress") {
                    VStack {
                        Text("\(Int(progress * 100))%")
                            .font(.title2)
                            .bold()
                        
                        Slider(value: $progress)
                            .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Update Progress")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(progress)
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview Provider
struct CurrentlyReadingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CurrentlyReadingView()
        }
    }
}
