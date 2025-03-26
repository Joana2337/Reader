//
///  ReaderBook.swift
///  Reader
///  Created by Joanne on 3/18/25.

import Foundation
import CoreData

@objc(ReaderBook)
public class ReaderBook: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var bookDescription: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var pageCount: Int32
    @NSManaged public var currentPage: Int32
    @NSManaged public var listType: String
    @NSManaged public var dateAdded: Date?
    @NSManaged private var authorsData: NSObject?
    
    public var authors: [String] {
        get {
            return (authorsData as? [String]) ?? []
        }
        set {
            authorsData = newValue as NSObject
        }
    }
    
    public var authorDisplay: String {
        return authors.isEmpty ? "Unknown Author" : authors.joined(separator: ", ")
    }
}

extension ReaderBook {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReaderBook> {
        return NSFetchRequest<ReaderBook>(entityName: "ReaderBook")
    }
}
