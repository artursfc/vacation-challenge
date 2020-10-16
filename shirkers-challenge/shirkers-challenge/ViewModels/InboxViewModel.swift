//
//  InboxViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 16/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import CoreData

// MARK: - Protocol-delegate
protocol InboxViewModelDelegate: AnyObject {
    func beginUpdates()
    func endUpdates()
}

final class InboxViewModel: NSObject {
    // MARK: - Properties
    private let context: NSManagedObjectContext

    private lazy var fetchedResultsController: NSFetchedResultsController<Recording> = {
        let fetchRequest: NSFetchRequest<Recording> = Recording.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Recording.modifiedAt, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "dueDate >= %@ AND isActive == true", Date() as NSDate)

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: self.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self

         return frc
    }()

    weak var delegate: InboxViewModelDelegate?

    // MARK: - Init
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - API
    var numberOfMemories: Int {
        guard let memories = fetchedResultsController.fetchedObjects else {
            return 0
        }
        return memories.count
    }

    func requestFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
            // TODO: Error Handling
        }
    }
}

// MARK: - FRC Delegate
extension InboxViewModel: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.endUpdates()
    }
}
