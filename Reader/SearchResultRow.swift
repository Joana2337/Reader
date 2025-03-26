
///  SearchResultRow.swift
///  Reader
///  Created by Joanne on 3/18/25.

import SwiftUI

struct SearchResultRow: View {
    let book: Book
    let onCurrentlyReading: () -> Void
    let onWantToRead: () -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let imageURL = book.volumeInfo.imageLinks?.secureImageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 90)
                    case .failure(_):
                        Image(systemName: "book.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 90)
                            .foregroundColor(.gray)
                    case .empty:
                        ProgressView()
                            .frame(width: 60, height: 90)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "book.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 90)
                    .foregroundColor(.gray)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(book.volumeInfo.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(book.volumeInfo.authorDisplay)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                if let description = book.volumeInfo.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .padding(.top, 2)
                }
                
                if let pageCount = book.volumeInfo.pageCount {
                    Text("\(pageCount) pages")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Button(action: onCurrentlyReading) {
                        Text("Currently Reading")
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: onWantToRead) {
                        Text("Want to Read")
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SearchResultRow(
        book: Book(
            id: "123",
            volumeInfo: VolumeInfo(
                title: "Sample Book",
                authors: ["Author Name"],
                description: "Sample description that is long enough to demonstrate text wrapping and multiple lines in the description area of the search result row.",
                imageLinks: ImageLinks(
                    smallThumbnail: "https://example.com/small.jpg",
                    thumbnail: "https://example.com/thumbnail.jpg"
                ),
                pageCount: 100
            )
        ),
        onCurrentlyReading: {},
        onWantToRead: {}
    )
}
