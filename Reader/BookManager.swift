//
//  BookManager.swift
//  Reader
//  Created by Joanne on 3/18/25.

import Foundation
import CoreData

class BookManager {
    let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }
    
    func addToCurrentlyReading(_ book: GoogleBook) throws {
        let fetchRequest = ReaderBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.id)
        
        let existingBooks = try viewContext.fetch(fetchRequest)
        if !existingBooks.isEmpty {
            throw BookError.alreadyExists
        }
        
        let _ = ReaderBook.from(googleBook: book, context: viewContext, listType: .currentlyReading)
        try viewContext.save()
    }
    
    func addToWantToRead(_ book: GoogleBook) throws {
        let fetchRequest = ReaderBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.id)
        
        let existingBooks = try viewContext.fetch(fetchRequest)
        if !existingBooks.isEmpty {
            throw BookError.alreadyExists
        }
        
        let _ = ReaderBook.from(googleBook: book, context: viewContext, listType: .wantToRead)
        try viewContext.save()
    }
    
    enum BookError: Error {
        case alreadyExists
    }
}
