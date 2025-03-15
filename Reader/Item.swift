//
//  Item.swift
//  Reader
//  Created by Joanne on 3/3/25.

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var title: String?
    var author: String?
    var progress: Double
    var imageURL: URL?
    
    init(timestamp: Date = .now, title: String? = nil, author: String? = nil, progress: Double = 0.0, imageURL: URL? = nil) {
        self.timestamp = timestamp
        self.title = title
        self.author = author
        self.progress = progress
        self.imageURL = imageURL
    }
}
