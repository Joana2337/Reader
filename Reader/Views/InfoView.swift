
///  InfoView.swift
///  Reader
///  Created by Joanne on 4/8/25.

import SwiftUI
import CoreData

struct InfoView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedListType: String? = nil
    
    var body: some View {
        VStack {
            /// Filter buttons
            HStack {
                Button("All Books") {
                    selectedListType = nil
                }
                .padding(.horizontal, 10)
                .background(selectedListType == nil ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(8)
                
                Button("Currently Reading") {
                    selectedListType = "currently_reading"
                }
                .padding(.horizontal, 10)
                .background(selectedListType == "currently_reading" ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(8)
                
                Button("Want to Read") {
                    selectedListType = "want_to_read"
                }
                .padding(.horizontal, 10)
                .background(selectedListType == "want_to_read" ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(8)
            }
            .padding(.top, 8)
            
            /// Book list
            BookList(listType: selectedListType)
                .environment(\.managedObjectContext, viewContext)
        }
    }
}

struct BookList: View {
    var listType: String?
    @FetchRequest var books: FetchedResults<ReaderBook>
    
    init(listType: String?) {
        let request: NSFetchRequest<ReaderBook> = ReaderBook.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ReaderBook.dateAdded, ascending: false)]
        
        if let listType = listType {
            request.predicate = NSPredicate(format: "listType == %@", listType)
        }
        
        _books = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        List {
            ForEach(books) { book in
                NavigationLink(destination: BookDetailView(book: book)) {
                    VStack(alignment: .leading) {
                        Text(book.title)
                            .font(.headline)
                        Text(book.authorDisplay)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    let preview = PersistenceController.preview
    let context = preview.container.viewContext
    
    /// Create sample books for preview
    if let book1 = try? ReaderBook(context: context) {
        book1.id = UUID().uuidString
        book1.title = "The Great Gatsby"
        book1.authorsString = "F. Scott Fitzgerald"
        book1.pageCount = 180
        book1.listType = "currently_reading"
        book1.dateAdded = Date()
    }
    
    if let book2 = try? ReaderBook(context: context) {
        book2.id = UUID().uuidString
        book2.title = "To Kill a Mockingbird"
        book2.authorsString = "Harper Lee"
        book2.pageCount = 281
        book2.listType = "want_to_read"
        book2.dateAdded = Date()
    }
    
    /// Save the context
    try? context.save()
    
    return NavigationStack {
        InfoView()
            .environment(\.managedObjectContext, context)
    }
}
