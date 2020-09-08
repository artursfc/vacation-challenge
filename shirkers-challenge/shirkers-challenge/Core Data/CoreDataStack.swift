//
//  CoreDataStack.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 06/09/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import CoreData
import os.log

final class CoreDataStack {

    private let model: String

    private lazy var managedModel: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: model, withExtension: "momd") else {
            os_log("Failed to locate model URL in Bundle.main", log: OSLog.coreDataStack, type: .error)
            fatalError("Failed to locate model URL in Bundle.main")
        }

        guard let managedModel = NSManagedObjectModel(contentsOf: url) else {
            os_log("Failed to initialize NSManagedObjectModel with model URL", log: .coreDataStack, type: .error)
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

    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    init(model: String) {
        self.model = model
    }
}
