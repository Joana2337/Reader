

import Foundation
import CloudKit

/// Represents different types of reading lists available in the app
/// - Created by: Joana

enum ReadingListType: String {
    case currentlyReading = "currently_reading_books"
    case wantToRead = "want_to_read_books"
}

/// Represents a book from the Google Books API
struct Book: Identifiable, Codable {
    /// Unique identifier for the book
    let id: String
    /// Contains detailed information about the book
    let volumeInfo: VolumeInfo
    
    // MARK: - Local Storage Methods
    /// Saves a book to local storage under a specific reading list
    /// - Parameters:
    ///   - book: The book to be saved
    ///   - listType: The type of reading list to save to
    static func saveLocally(_ book: Book, listType: ReadingListType) {
        var books = getLocalBooks(listType: listType)
        
        // Check if book already exists
        guard !books.contains(where: { $0.id == book.id }) else { return }
        
        books.append(book)
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(books) {
            UserDefaults.standard.set(encoded, forKey: listType.rawValue)
        }
    }
    
    /// Retrieves books from local storage for a specific reading list
    /// - Parameter listType: The type of reading list to fetch from
    /// - Returns: Array of books in the specified list
    static func getLocalBooks(listType: ReadingListType) -> [Book] {
        guard let data = UserDefaults.standard.data(forKey: listType.rawValue),
              let books = try? JSONDecoder().decode([Book].self, from: data) else {
            return []
        }
        return books
    }
    
    /// Removes a book from local storage
    /// - Parameters:
    ///   - book: The book to be removed
    ///   - listType: The type of reading list to remove from
    static func removeFromLocal(_ book: Book, listType: ReadingListType) {
        var books = getLocalBooks(listType: listType)
        books.removeAll { $0.id == book.id }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(books) {
            UserDefaults.standard.set(encoded, forKey: listType.rawValue)
        }
    }
}

/// Contains detailed information about a book
struct VolumeInfo: Codable {
    /// Title of the book
    let title: String
    /// Authors of the book (if available)
    let authors: [String]?
    /// Book description (if available)
    let description: String?
    /// Links to book cover images (if available)
    let imageLinks: ImageLinks?
    
    /// Computed property to display authors in a readable format
    var authorDisplay: String {
        authors?.joined(separator: ", ") ?? "Unknown Author"
    }
}

/// Contains URLs for book cover images
struct ImageLinks: Codable {
    /// URL for small thumbnail image
    let smallThumbnail: String?
    /// URL for thumbnail image
    let thumbnail: String?
    
    /// Computed property to get HTTPS version of thumbnail URL
    var secureImageURL: URL? {
        guard let thumbnail = thumbnail else { return nil }
        let secureURL = thumbnail.replacingOccurrences(of: "http://", with: "https://")
        return URL(string: secureURL)
    }
}

/// Response structure from Google Books API
struct BookResult: Codable {
    /// Array of books returned from the API
    let items: [Book]
}

// MARK: - String Extension
extension String {
    /// URL-encoded version of the string
    var urlEncoded: String? {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
