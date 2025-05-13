
///  ReaderBook.swift
///  Reader
///  Created by Joanne on 3/18/25.
/// Using core date  to :
/// Store and organize all books in the application
/// Save book details like title, authour, and cover images
///  Keeps these inforamation even when the app closes and is re-opened. 

import Foundation
import CoreData

@objc(ReaderBook)
public class ReaderBook: NSManagedObject, Identifiable {
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var bookDescription: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var pageCount: Int32
    @NSManaged public var currentPage: Int32
    @NSManaged public var listType: String
    @NSManaged public var dateAdded: Date?
    @NSManaged public var authorsString: String?
    
    public var authors: [String] {
        get {
            if let authorsString = authorsString, !authorsString.isEmpty {
                return authorsString.components(separatedBy: ",")
            }
            return []
        }
        set {
            authorsString = newValue.joined(separator: ",")
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
