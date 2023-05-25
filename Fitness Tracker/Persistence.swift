//
//  Persistence.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 25/05/2023.
//

import Foundation
import CoreData

class Persistence: ObservableObject {
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FitnessTracker")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
}
