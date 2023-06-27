//
//  Persistence.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 06/06/2023.
//

import Foundation
import CoreData

// Provides a persistent container to use in the app and sample data for the previews
class Persistence {
    /// Check to instantiate an in-memory store when accessing container
    var inMemory = false
    
    init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }
    
    /// Container to use for handling CoreData interactions
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FitnessTracker")
        if (self.inMemory) {
            container.persistentStoreDescriptions.first?.type = NSInMemoryStoreType
        }
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Could not load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    /// The preview object to use with previews
    static let preview: Persistence = {
        let persistence = Persistence(inMemory: true)
        return persistence
    }()
    
    /// Utility function for saving changes to the context
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("Error saving content: \(error)")
            }
        } else {
            print("No changes to save")
        }
    }
}
