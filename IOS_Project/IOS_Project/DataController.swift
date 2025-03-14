//
//  DataController.swift
//  IOS_Project
//
//  Created by Hamza Omar khan on 2025-03-12.
//
import Foundation
import CoreData

class DataController: ObservableObject {
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "Storage") // Your Core Data model name
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data: \(error.localizedDescription)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return container.viewContext
    }

    // Save function
    func save() {
        do {
            try context.save()
        } catch {
            print("Failed to save Core Data: \(error.localizedDescription)")
        }
    }
}
