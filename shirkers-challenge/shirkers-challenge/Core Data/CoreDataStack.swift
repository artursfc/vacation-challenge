//
//  CoreDataStack.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 06/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import CoreData
import os.log

/// The object responsible for the instatiantion and managing of Core Data.
final class CoreDataStack {
    //- MARK: Store type
    /// The available store types.
    enum StoreType {
        /// Store type used in production to save to a `.sqlite` file.
        case sqlite
        /// Store type used when testing. It saves to memory.
        case inMemory
    }
    // - MARK: Properties
    /// The model's name.
    private let model: String

    /// The store type. It is set as `.sqlite` by default.
    /// `.inMemory` should be used when testing.
    private let storeType: StoreType

    /// The store description based on the store type and model name.
    private var storeDescription: NSPersistentStoreDescription {
        switch storeType {
        case .sqlite:
            let defaultURL = NSPersistentContainer.defaultDirectoryURL()
            let sqliteURL = defaultURL.appendingPathComponent("\(self.model).sqlite")
            let storeDescription = NSPersistentStoreDescription(url: sqliteURL)

            storeDescription.shouldAddStoreAsynchronously = false
            storeDescription.shouldInferMappingModelAutomatically = true
            storeDescription.shouldMigrateStoreAutomatically = true

            return storeDescription
        case .inMemory:
            let inMemoryURL = URL(fileURLWithPath: "/dev/null")
            let storeDescription = NSPersistentStoreDescription(url: inMemoryURL)

            storeDescription.shouldAddStoreAsynchronously = false
            storeDescription.shouldInferMappingModelAutomatically = true
            storeDescription.shouldMigrateStoreAutomatically = true

            return storeDescription
        }
    }

    /// A lazily instantiated instance of `NSPersistentContainer` with the
    /// `automaticallyMergesChangesFromParent` property of its `viewContext`
    /// set to `true`.
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.model)
        container.persistentStoreDescriptions = [storeDescription]

        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }

            container.viewContext.automaticallyMergesChangesFromParent = true
        }

        return container
    }()

    // - MARK: Contexts
    /// A read-only computed property to access the context of the
    /// `NSPersistentContainer`. It should only be used for UI-related actions.
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    /// The context for background tasks.
    /// It should be used for non-UI related tasks, especially computationally or time-consuming ones.
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = container.newBackgroundContext()
        return context
    }()

    // - MARK: Init
    /// Initializes a new instance of this type.
    /// - Parameter model: The model's name.
    init(model: String, storeType: CoreDataStack.StoreType = .sqlite) {
        self.model = model
        self.storeType = storeType
    }
}
