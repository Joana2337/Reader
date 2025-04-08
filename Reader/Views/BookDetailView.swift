
///  BookDetailView.swift
///  Reader
///  Created by Joanne on 4/8/25.

import SwiftUI

struct BookDetailView: View {
    var book: ReaderBook
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                /// Book image if available
                if let imageURL = book.imageURL, !imageURL.isEmpty {
                    AsyncImage(url: URL(string: imageURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                                .cornerRadius(8)
                        case .failure:
                            Image(systemName: "book.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 200)
                                .foregroundColor(.gray)
                        case .empty:
                            ProgressView()
                                .frame(height: 200)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)
                }
                
                Text(book.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                Text("Author(s): \(book.authorDisplay)")
                    .font(.subheadline)
                    .padding(.bottom, 5)
                
                Text("Number of Pages: \(book.pageCount)")
                    .font(.subheadline)
                    .padding(.bottom, 5)
                
                if book.listType == "currently_reading" {
                    Text("Your Progress: \(book.currentPage)/\(book.pageCount) pages")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.bottom, 5)
                }
                
                Divider()
                
                Text("Description:")
                    .font(.headline)
                    .padding(.vertical, 5)
                
                Text(book.bookDescription ?? "No description available")
                    .font(.body)
                    .padding(.bottom, 10)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Book Details")
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sampleBook = ReaderBook(context: context)
    sampleBook.id = UUID().uuidString
    sampleBook.title = "Sample Book"
    sampleBook.authorsString = "Author One,Author Two"
    sampleBook.bookDescription = "This is a sample book description that would typically come from the Google Books API."
    sampleBook.pageCount = 300
    sampleBook.currentPage = 75
    sampleBook.listType = "currently_reading"
    sampleBook.dateAdded = Date()
    
    return BookDetailView(book: sampleBook)
        .environment(\.managedObjectContext, context)
}
