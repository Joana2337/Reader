
//  WantToRead.swift
//  Reader
//  Created by Joanne on 3/15/25.

import SwiftUI
import CoreData

struct WantToReadView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: ReaderBook.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ReaderBook.title, ascending: true)],
        predicate: NSPredicate(format: "listType == %@", ReadingListType.wantToRead.rawValue)
    ) private var books: FetchedResults<ReaderBook>
    
    var body: some View {
        List {
            ForEach(books, id: \.id) { book in
                BookRow(book: book)
            }
            .onDelete(perform: deleteBooks)
        }
        .navigationTitle("Want to Read")
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

struct WantToReadView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            WantToReadView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
