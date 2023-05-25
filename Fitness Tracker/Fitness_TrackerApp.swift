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
    @StateObject var persistence = Persistence()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
        }
    }
}
