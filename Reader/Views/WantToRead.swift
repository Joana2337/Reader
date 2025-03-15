
//  WantToRead.swift
//  Reader
//  Created by Joanne on 3/15/25.

import SwiftUI

struct WantToReadView: View {
    // MARK: - State Management
    /// Stores the list of books in want to read list
    @State private var books: [Book] = []
    /// Controls visibility of alert
    @State private var showingAlert = false
    /// Stores alert message
    @State private var alertMessage = ""
    
    // MARK: - View Body
    var body: some View {
        List {
            if books.isEmpty {
                // Display when no books are in want to read list
                ContentUnavailableView(
                    "No Books in Want to Read",
                    systemImage: "book.closed",
                    description: Text("Add books you're interested in reading")
                )
            } else {
                // List of books in want to read
                ForEach(books) { book in
                    WantToReadRow(book: book)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                removeBook(book)
                            } label: {
                                Label("Remove", systemImage: "trash")
                            }
                            
                            Button {
                                moveToCurrentlyReading(book)
                            } label: {
                                Label("Start Reading", systemImage: "book.fill")
                            }
                            .tint(.green)
                        }
                }
            }
        }
        .navigationTitle("Want to Read")
        .onAppear {
            loadBooks()
        }
        .alert("Reader", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Helper Methods
    /// Loads books from local storage marked as want to read
    private func loadBooks() {
        books = Book.getLocalBooks(listType: .wantToRead)
    }
    
    /// Removes a book from the Want to Read list
    /// - Parameter book: The book to be removed
    private func removeBook(_ book: Book) {
        Book.removeFromLocal(book, listType: .wantToRead)
        loadBooks()
        alertMessage = "Book removed from Want to Read"
        showingAlert = true
    }
    
    
    /// Moves a book from Want to Read to Currently Reading
    /// - Parameter book: The book to move
    private func moveToCurrentlyReading(_ book: Book) {
        // Remove from Want to Read
        Book.removeFromLocal(book, listType: .wantToRead)
        
        // Add to Currently Reading
        Book.saveLocally(book, listType: .currentlyReading)
        
        // Update UI
        loadBooks()
        
        // Show confirmation
        alertMessage = "Book moved to Currently Reading"
        showingAlert = true
    }
}

// MARK: - Supporting Views
struct WantToReadRow: View {
    let book: Book
    
    var body: some View {
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
                        .padding(.top, 4)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview Provider
struct WantToReadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WantToReadView()
        }
    }
}
