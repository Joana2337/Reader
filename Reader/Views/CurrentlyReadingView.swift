
/// CurrentlyReadingView displays and manages the user's active reading list
/// Allows users to track their reading progress for each book
/// - Created by: Joana
/// - Date: 2025-03-15

import SwiftUI
import CoreData

struct CurrentlyReadingView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: ReaderBook.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ReaderBook.title, ascending: true)],
        predicate: NSPredicate(format: "listType == %@", ReadingListType.currentlyReading.rawValue)
    ) private var books: FetchedResults<ReaderBook>
    
    var body: some View {
        List {
            ForEach(books, id: \.id) { book in
                BookRow(book: book)
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
    
    private func deleteBooks(at offsets: IndexSet) {
        for index in offsets {
            let book = books[index]
            viewContext.delete(book)
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error deleting book: \(error)")
        }
    }
}

struct CurrentlyReadingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CurrentlyReadingView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
