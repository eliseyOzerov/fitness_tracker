//
//  Fitness_TrackerApp.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 01/05/2023.
//

import SwiftUI
import CoreData

@main
struct Fitness_TrackerApp: App {
    let persistence = Persistence()
    
    var body: some Scene {
        let context = persistence.container.viewContext
        let coordinator = persistence.container.persistentStoreCoordinator
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, context)
        }
    }
}
