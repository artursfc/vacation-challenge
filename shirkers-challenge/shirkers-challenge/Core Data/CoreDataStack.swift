//
//  CoreDataStack.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 06/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import CoreData
import os.log

/// The object responsible for instatiantion and managing of Core Data.
/// It makes use of the `NSPersistentContainer` with its
/// `viewContext.automaticallyMergesChangesFromParent = true`.
final class CoreDataStack {
    // - MARK: Properties
    private let model: String

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.model)
        let defaultURL = NSPersistentContainer.defaultDirectoryURL()
        let persistentDescription = NSPersistentStoreDescription(url: defaultURL)

        container.persistentStoreDescriptions = [persistentDescription]
        container.viewContext.automaticallyMergesChangesFromParent = true

        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error)")
            }
        }
        return container
    }()

    // - MARK: Contexts
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    // - MARK: Init
    init(model: String) {
        self.model = model
    }

    func save() {
        if mainContext.hasChanges {
            do {
                try mainContext.save()
            } catch {
                os_log("Failed to save changes from main context", log: .coreDataStack, type: .error)
            }
        }
    }
}
