//
//  Book.swift
//  Reader
//  Created by Joanne on 3/18/25.

// This handles Google Books API data
import Foundation

struct Book: Identifiable, Codable {
    let id: String
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]?
    let description: String?
    let imageLinks: ImageLinks?
    
    var authorDisplay: String {
        authors?.joined(separator: ", ") ?? "Unknown Author"
    }
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
    
    var secureImageURL: URL? {
        guard let thumbnail = thumbnail else { return nil }
        let secureURL = thumbnail.replacingOccurrences(of: "http://", with: "https://")
        return URL(string: secureURL)
    }
}

struct BookResult: Codable {
    let items: [Book]
}
