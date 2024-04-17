//
//  CoreDataManager.swift
//  KekaAssignment
//
//  Created by Shaikh Rakib on 17/04/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager(modelName: "KekaAssignment")
    
    private let persistentContainer: NSPersistentContainer
    
    private init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Failed to load CoreData stack: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
            return persistentContainer.viewContext
        }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Failed to save context: \(error)")
            }
        }
    }
    
    func saveObjects<T: NSManagedObject>(objects: [T], uniqueIdentifier: String) {
        for object in objects {
            let entityName = String(describing: T.self)
            guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
                print("Error: Failed to get entity description for \(entityName)")
                continue
            }
            
            let identifier = object.value(forKey: uniqueIdentifier) // Assuming "identifier" is the unique property
            
            let fetchRequest = NSFetchRequest<T>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "\(uniqueIdentifier) == %@", identifier as! CVarArg)
            
            do {
                let existingObjects = try context.fetch(fetchRequest)
                if !existingObjects.isEmpty {
                    print("Object with identifier \(uniqueIdentifier) already exists. Skipping.")
                    continue
                } else {
                    let managedObject = NSManagedObject(entity: entity, insertInto: context)
                    
                    // Set properties of managedObject from object properties
                    for attribute in entity.attributesByName {
                        if let value = object.value(forKey: attribute.key) {
                            managedObject.setValue(value, forKey: attribute.key)
                        }
                    }
                    try context.save()
                }
            } catch {
                print("Error fetching existing objects: \(error)")
                continue
            }
        }
    }
    
    func fetch<T: NSManagedObject>(entityType: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) -> [T] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: entityType))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError("Failed to fetch \(entityType) entities: \(error)")
        }
    }
    
    func delete<T: NSManagedObject>(object: T) {
        let context = persistentContainer.viewContext
        context.delete(object)
        saveContext()
    }
}
