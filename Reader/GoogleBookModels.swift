
import Foundation

/// Google Books API Models
struct GoogleBookResult: Codable {
    let items: [GoogleBook]
}

struct GoogleBook: Identifiable, Codable {
    let id: String
    let volumeInfo: GoogleVolumeInfo
}

struct GoogleVolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: GoogleImageLinks?
    let pageCount: Int?
    
    var authorDisplay: String {
        authors?.joined(separator: ", ") ?? "Unknown Author"
    }
}

struct GoogleImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
    
    var secureImageURL: URL? {
        // Try thumbnail first, then fallback to smallThumbnail
        if let thumbnail = thumbnail {
            let secureURL = thumbnail.replacingOccurrences(of: "http://", with: "https://")
            return URL(string: secureURL)
        } else if let smallThumbnail = smallThumbnail {
            let secureURL = smallThumbnail.replacingOccurrences(of: "http://", with: "https://")
            return URL(string: secureURL)
        }
        return nil
    }
}
