
//  PersistenceController.swift
//  Reader
//  Created by Joanne on 3/18/25.


import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let sampleBook = ReaderBook(context: viewContext)
        sampleBook.id = "1"
        sampleBook.title = "The Great Gatsby"
        sampleBook.authors = ["F. Scott Fitzgerald"]
        sampleBook.bookDescription = "A story of the mysteriously wealthy Jay Gatsby"
        sampleBook.imageURL = "https://example.com/gatsby.jpg"
        sampleBook.pageCount = 180
        sampleBook.listType = ReadingListType.currentlyReading.rawValue
        
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Reader")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
