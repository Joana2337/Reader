
///  BookManager.swift
///  Reader
///  Created by Joanne on 3/18/25.


import Foundation
import CoreData
import SwiftUI

enum BookError: Error {
    case alreadyExists
}

class BookManager: ObservableObject {
    private let viewContext: NSManagedObjectContext
    
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
        
        let readerBook = ReaderBook(context: viewContext)
        readerBook.id = book.id
        readerBook.title = book.volumeInfo.title
        readerBook.authors = book.volumeInfo.authors ?? []
        readerBook.bookDescription = book.volumeInfo.description
        readerBook.imageURL = book.volumeInfo.imageLinks?.secureImageURL?.absoluteString // Use the secure URL
        readerBook.pageCount = Int32(book.volumeInfo.pageCount ?? 0)
        readerBook.currentPage = 0
        readerBook.listType = ReadingListType.currentlyReading.rawValue
        readerBook.dateAdded = Date()
        
        try viewContext.save()
    }
    
    func addToWantToRead(_ book: GoogleBook) throws {
        let fetchRequest = ReaderBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", book.id)
        
        let existingBooks = try viewContext.fetch(fetchRequest)
        if !existingBooks.isEmpty {
            throw BookError.alreadyExists
        }
        
        let readerBook = ReaderBook(context: viewContext)
        readerBook.id = book.id
        readerBook.title = book.volumeInfo.title
        readerBook.authors = book.volumeInfo.authors ?? []
        readerBook.bookDescription = book.volumeInfo.description
        readerBook.imageURL = book.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http://", with: "https://")
        readerBook.pageCount = Int32(book.volumeInfo.pageCount ?? 0)
        readerBook.currentPage = 0
        readerBook.listType = ReadingListType.wantToRead.rawValue
        readerBook.dateAdded = Date()
        
        try viewContext.save()
    }
    
    func updateReadingProgress(_ book: ReaderBook, currentPage: Int32) {
        book.currentPage = currentPage
        
        do {
            try viewContext.save()
        } catch {
            print("Error updating reading progress: \(error)")
        }
    }
    
    func moveToCurrentlyReading(_ book: ReaderBook) {
        book.listType = ReadingListType.currentlyReading.rawValue
        book.currentPage = 0
        
        do {
            try viewContext.save()
        } catch {
            print("Error moving book to Currently Reading: \(error)")
        }
    }
    
    func removeBook(_ book: ReaderBook) {
        viewContext.delete(book)
        
        do {
            try viewContext.save()
        } catch {
            print("Error removing book: \(error)")
        }
    }
    
    func fetchCurrentlyReading() -> [ReaderBook] {
        let request = NSFetchRequest<ReaderBook>(entityName: "ReaderBook")
        request.predicate = NSPredicate(format: "listType == %@", ReadingListType.currentlyReading.rawValue)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ReaderBook.dateAdded, ascending: false)]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching currently reading: \(error)")
            return []
        }
    }
    
    func fetchWantToRead() -> [ReaderBook] {
        let request = NSFetchRequest<ReaderBook>(entityName: "ReaderBook")
        request.predicate = NSPredicate(format: "listType == %@", ReadingListType.wantToRead.rawValue)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ReaderBook.dateAdded, ascending: false)]
        
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Error fetching want to read: \(error)")
            return []
        }
    }
}
