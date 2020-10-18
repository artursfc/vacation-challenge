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
    func insertNewMemoryAt(_ index: IndexPath)
    func updates(from blocks: [BlockOperation])
}

final class InboxViewModel: NSObject {
    // MARK: - Properties
    private let context: NSManagedObjectContext

    private var updateBlock: [BlockOperation] = [BlockOperation]()

    private lazy var fetchedResultsController: NSFetchedResultsController<Recording> = {
        let fetchRequest: NSFetchRequest<Recording> = Recording.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Recording.modifiedAt, ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "dueDate =< %@ AND isActive == true", Date() as NSDate)

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

    var didUpdate: Bool = false {
        didSet {
            if didUpdate {
                updateBlock.removeAll(keepingCapacity: false)
            }
        }
    }

    func requestFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
            // TODO: Error Handling
        }
    }

    func viewModelAt(index: IndexPath) -> MemoryViewModel {
        let memory = fetchedResultsController.object(at: index)

        guard let title = memory.title,
                   let createdAt = memory.createdAt?.stringFormatted(),
                   let modifiedAt = memory.modifiedAt?.stringFormatted(),
                   let period = memory.dueDate?.stringFormatted() else {
                    return MemoryViewModel()
                   }

        return MemoryViewModel(title: title,
                               createdAt: createdAt,
                               isActive: memory.isActive,
                               modifiedAt: modifiedAt,
                               period: period)
    }
}

// MARK: - FRC Delegate
extension InboxViewModel: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updateBlock.removeAll(keepingCapacity: false)
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        let block = BlockOperation { [weak self] in
            guard let self = self else { return }
            switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    self.delegate?.insertNewMemoryAt(newIndexPath)
                }
            default:
                break
            }
        }
        updateBlock.append(block)
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.updates(from: updateBlock)
    }
}
