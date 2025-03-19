
//  BookRow.swift
//  Reader
//  Created by Joanne on 3/18/25.


import SwiftUI

struct BookRow: View {
    let book: ReaderBook
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // Book Cover Image
                if let imageURLString = book.imageURL,
                   let url = URL(string: imageURLString) {
                    AsyncImage(url: url) { image in
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
                    Text(book.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(book.authorDisplay)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let description = book.bookDescription {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = ReaderBook(context: context)
        book.id = "1"
        book.title = "The Great Gatsby"
        book.authors = ["F. Scott Fitzgerald"]
        book.bookDescription = "A story of the mysteriously wealthy Jay Gatsby"
        book.imageURL = "https://example.com/gatsby.jpg"
        book.pageCount = 180
        book.listType = ReadingListType.currentlyReading.rawValue
        
        return BookRow(book: book)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
