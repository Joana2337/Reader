
/// CurrentlyReadingView displays and manages the user's active reading list
/// Allows users to track their reading progress for each book they've added to currently reading.
/// - Created by: Joana
/// - Date: 2025-03-15

import SwiftUI
import CoreData

struct CurrentlyReadingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ReaderBook.title, ascending: true)],
        predicate: NSPredicate(format: "listType == %@", ReadingListType.currentlyReading.rawValue)
    ) private var books: FetchedResults<ReaderBook>
    
    @State private var bookForProgress: ReaderBook?
    @State private var showingProgressSheet = false
    @State private var bookForInfo: ReaderBook?
    @State private var showingInfoSheet = false
    
    var body: some View {
        List {
            ForEach(books, id: \.id) { book in
                VStack(alignment: .leading) {
                    BookRow(book: book)
                    
                    // Progress section
                    VStack(alignment: .leading) {
                        SwiftUI.ProgressView(value: Double(book.currentPage), total: Double(book.pageCount))
                        
                        HStack {
                            Text("Page \(Int(book.currentPage)) of \(Int(book.pageCount))")
                            Spacer()
                            if book.pageCount > 0 {
                                Text("\(Int((Double(book.currentPage) / Double(book.pageCount)) * 100))%")
                            }
                        }
                        .font(.caption)
                        
                        // ADDED: Both buttons side by side
                        HStack {
                            // Update Progress button
                            Button("Update Progress") {
                                bookForProgress = book
                                showingProgressSheet = true
                            }
                            .buttonStyle(.bordered)
                            .tint(.blue)
                            
                            // Info button
                            Button {
                                bookForInfo = book
                                showingInfoSheet = true
                            } label: {
                                Label("Info", systemImage: "info.circle.fill")
                            }
                            .buttonStyle(.bordered)
                            .tint(.purple)
                        }
                    }
                    .padding(.top, 8)
                }
            }
            .onDelete(perform: deleteBooks)
        }
        .navigationTitle("Currently Reading")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        //Progress sheet
        .sheet(isPresented: $showingProgressSheet) {
            if let book = bookForProgress {
                PageProgressView(book: book, viewContext: viewContext)
            }
        }
        // ADDED: Info sheet
        .sheet(isPresented: $showingInfoSheet) {
            if let book = bookForInfo {
                BookDetailView(book: book)
            }
        }
    }
    
    private func deleteBooks(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(books[index])
        }
        try? viewContext.save()
    }
}


//#Preview {
//    NavigationView {
//        CurrentlyReadingView()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
