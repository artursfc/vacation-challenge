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

    private lazy var managedModel: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: model, withExtension: "momd") else {
            fatalError("Failed to locate model URL in Bundle.main")
        }

        guard let managedModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to initialize NSManagedObjectModel with model URL")
        }
        return managedModel
    }()

    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.model, managedObjectModel: self.managedModel)
        let defaultURL = NSPersistentContainer.defaultDirectoryURL()
        let persistentDescription = NSPersistentStoreDescription(url: defaultURL)

        container.persistentStoreDescriptions = [persistentDescription]
        container.viewContext.automaticallyMergesChangesFromParent = true

        container.loadPersistentStores { (_, error) in
            if let error = error {
                os_log("Failed to load persistent store", log: .coreDataStack, type: .error)
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
}
