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

    /// The model's name.
    private let model: String

    /// A lazily instantiated instance of `NSPersistentContainer` with the
    /// `automaticallyMergesChangesFromParent` property of its `viewContext`
    /// set to `true`.
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.model)

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

    // - MARK: Init
    /// Initializes a new instance of this type.
    /// - Parameter model: The model's name.
    init(model: String) {
        self.model = model
    }
}
