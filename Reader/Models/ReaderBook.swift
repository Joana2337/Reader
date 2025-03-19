//
//  ReaderBook.swift
//  Reader
//  Created by Joanne on 3/18/25.

import Foundation
import CoreData

@objc(ReaderBook)
public class ReaderBook: NSManagedObject, Identifiable {
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var authors: [String]
    @NSManaged public var bookDescription: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var pageCount: Int32
    @NSManaged public var listType: String
    
    var readingListType: ReadingListType {
        get {
            return ReadingListType(rawValue: listType) ?? .wantToRead
        }
        set {
            listType = newValue.rawValue
        }
    }
    
    var authorDisplay: String {
        return authors.joined(separator: ", ")
    }
    
    static func from(googleBook: GoogleBook, context: NSManagedObjectContext, listType: ReadingListType) -> ReaderBook {
        let book = ReaderBook(context: context)
        book.id = googleBook.id
        book.title = googleBook.volumeInfo.title
        book.authors = googleBook.volumeInfo.authors ?? []
        book.bookDescription = googleBook.volumeInfo.description
        book.imageURL = googleBook.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http://", with: "https://")
        book.pageCount = 0
        book.listType = listType.rawValue
        return book
    }
}

extension ReaderBook {
    static var fetchRequest: NSFetchRequest<ReaderBook> {
        return NSFetchRequest<ReaderBook>(entityName: "ReaderBook")
    }
}
