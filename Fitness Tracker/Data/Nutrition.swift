//
//  Nutrition.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 05/06/2023.
//

import Foundation
import CoreData

class NutritionData: ObservableObject {
    let context: NSManagedObjectContext
    
    init(_ context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Data
    
    @Published var foodItems: [FoodItem] = []
}
