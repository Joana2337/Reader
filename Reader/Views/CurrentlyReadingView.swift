
/// CurrentlyReadingView displays and manages the user's active reading list
/// Allows users to track their reading progress for each book
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
    
    var body: some View {
        List {
            ForEach(books, id: \.id) { book in
                VStack(alignment: .leading) {
                    BookRow(book: book)
                    
                    /// Add progress section
                    VStack(alignment: .leading) {
                        ProgressView(value: Double(book.currentPage), total: Double(book.pageCount))
                        
                        HStack {
                            Text("Page \(Int(book.currentPage)) of \(Int(book.pageCount))")
                            Spacer()
                            if book.pageCount > 0 {
                                Text("\(Int((Double(book.currentPage) / Double(book.pageCount)) * 100))%")
                            }
                        }
                        .font(.caption)
                        
                        Button("Update Progress") {
                            /// Show update sheet
                            updateProgress(for: book)
                        }
                        .buttonStyle(.bordered)
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
    }
    
    private func updateProgress(for book: ReaderBook) {
        /// Show an alert to update progress
        let alert = UIAlertController(title: "Update Progress", message: "Enter current page:", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.keyboardType = .numberPad
            textField.text = String(Int(book.currentPage))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Update", style: .default) { _ in
            if let text = alert.textFields?.first?.text,
               let page = Int(text) {
                book.currentPage = Int32(min(max(0, page), Int(book.pageCount)))
                try? viewContext.save()
            }
        })
        
        /// Present the alert
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let viewController = windowScene.windows.first?.rootViewController {
            viewController.present(alert, animated: true)
        }
    }
    
    private func deleteBooks(at offsets: IndexSet) {
        for index in offsets {
            viewContext.delete(books[index])
        }
        try? viewContext.save()
    }
}

#Preview {
    NavigationView {
        CurrentlyReadingView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
