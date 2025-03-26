
//  BookRow.swift
//  Reader
//  Created by Joanne on 3/18/25.

import SwiftUI
import SwiftUI

struct BookRow: View {
    let book: ReaderBook
    @State private var showingProgressAlert = false
    @State private var currentPage = ""
    @State private var showingMoveAlert = false
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var bookManager = BookManager(context: PersistenceController.shared.container.viewContext)
    
    var isCurrentlyReading: Bool {
        return book.listType == ReadingListType.currentlyReading.rawValue
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Book cover image
            if let imageURLString = book.imageURL,
               let imageURL = URL(string: imageURLString) {
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
            
            // Book details
            VStack(alignment: .leading, spacing: 4) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(book.authorDisplay)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                if isCurrentlyReading && book.pageCount > 0 {
                    Button(action: {
                        currentPage = String(book.currentPage)
                        showingProgressAlert = true
                    }) {
                        Text("\(book.currentPage) of \(book.pageCount) pages")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if !isCurrentlyReading {
                showingMoveAlert = true
            }
        }
        .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
        .alert("Update Reading Progress", isPresented: $showingProgressAlert) {
            TextField("Current Page", text: $currentPage)
                .keyboardType(.numberPad)
                .frame(maxWidth: .infinity)
                .fixedSize()
            Button("Update") {
                if let page = Int32(currentPage), page >= 0, page <= book.pageCount {
                    bookManager.updateReadingProgress(book, currentPage: page)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Enter the current page (0-\(book.pageCount))")
        }
        .alert("Move to Currently Reading?", isPresented: $showingMoveAlert) {
            Button("Move") {
                bookManager.moveToCurrentlyReading(book)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Start reading \(book.title)?")
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                bookManager.removeBook(book)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct BookRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let book = ReaderBook(context: context)
        book.id = "test_id"
        book.title = "Sample Book"
        book.authors = ["John Doe"]
        book.pageCount = 300
        book.currentPage = 150
        book.imageURL = nil
        book.listType = ReadingListType.currentlyReading.rawValue
        book.dateAdded = Date()
        
        return BookRow(book: book)
            .environment(\.managedObjectContext, context)
    }
}
