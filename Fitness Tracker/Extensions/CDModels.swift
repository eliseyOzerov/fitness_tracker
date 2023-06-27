//
//  CDModels.swift
//  Fitness Tracker
//
//  Created by Elisey Ozerov on 14/06/2023.
//

import Foundation
import CoreData

extension FoodItem {
    static var preview: FoodItem {
        let context = Persistence.preview.container.viewContext
        let item = makePreview(context)
        return item
    }
    
    static func makePreview(_ context: NSManagedObjectContext) -> FoodItem {
        let item = FoodItem(context: context)
        item.barcode = "123456"
        item.title = "Test item"
        item.brand = "Brandeed"
        item.notes = "Here are some notes on how to do anything ever with this item"
        item.calories = 243
        item.protein = 40
        item.carbs = 120
        item.fats = 10
        return item
    }
}

extension LoggedFood {
    static var preview: LoggedFood {
        let context = Persistence.preview.container.viewContext
        let item = makePreview(context)
        return item
    }
    
    static func makePreview(_ context: NSManagedObjectContext) -> LoggedFood {
        let item = LoggedFood(context: context)
        item.amount = 100
        item.dateTime = Date()
        item.item = FoodItem.preview
        return item
    }
}
