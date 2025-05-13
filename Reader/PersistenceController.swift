
///  PersistenceController.swift
///  Reader
///  Created by Joanne on 3/18/25.

import CoreData
import CloudKit

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Reader") ///since am using NSPersistentCloudkit container, the cloudkit have been integrated. Force quitting the application with some books saved should back as it was. 
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("###\(#function): Failed to retrieve a persistent store description.")
        }
        
        /// Set up for local development
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        return result
    }()
}
