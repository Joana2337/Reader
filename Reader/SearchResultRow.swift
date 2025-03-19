//
//  SearchResultRow.swift
//  Reader
//
//  Created by Joanne on 3/18/25.


import SwiftUI

struct SearchResultRow: View {
    let book: GoogleBook  // Changed from Book to GoogleBook
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
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(isPressingCurrently ? 0.95 : 1.0)
                        .font(.caption)
                        .foregroundColor(.blue)
                        
                        Spacer()
                        
                        // Want to Read Button
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

struct SearchResultRow_Previews: PreviewProvider {
    static var previews: some View {
        let sampleBook = GoogleBook(
            id: "1",
            volumeInfo: GoogleVolumeInfo(
                title: "The Great Gatsby",
                authors: ["F. Scott Fitzgerald"],
                description: "A story of the mysteriously wealthy Jay Gatsby",
                imageLinks: GoogleImageLinks(
                    smallThumbnail: "https://example.com/small.jpg",
                    thumbnail: "https://example.com/gatsby.jpg"
                )
            )
        )
        
        SearchResultRow(
            book: sampleBook,
            onCurrentlyReading: {},
            onWantToRead: {}
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
