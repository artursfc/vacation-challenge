//
//  ArchiveViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 13/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import CoreData

// MARK: - Protocol-Delegate
/// The delegate responsible for allowing communication between
/// `ArchiveViewModel` and its `View`.
protocol ArchiveViewModelDelegate: AnyObject {
    func beginUpdates()
    func insertNewMemoryAt(_ index: IndexPath)
    func deleteMemoryAt(_ index: IndexPath)
    func endUpdates()
}

/// Responsible for providing the `View` with all the necessary
/// funcionalities and data for displaying the archive of memories.
final class ArchiveViewModel: NSObject {
    // MARK: - Properties
    /// The context used to access Core Data through a FRC.
    private let context: NSManagedObjectContext

    /// The FRC responsible for fetching memories. It orders memories
    /// by last modified.
    private lazy var fetchedResultsController: NSFetchedResultsController<Recording> = {
        let fetchRequest: NSFetchRequest<Recording> = Recording.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Recording.modifiedAt, ascending: false)]

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: self.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self

        return frc
    }()

    /// The delegate responsible for allowing communication between
    /// `ArchiveViewModel` and its `View`.
    weak var delegate: ArchiveViewModelDelegate?

    // MARK: - Init
    /// Initializes a new instance of this type.
    /// - Parameter context: The context used to access Core Data through a FRC.
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - API
    /// The number of memories fetched by the FRC.
    var numberOfMemories: Int {
        guard let memories = fetchedResultsController.fetchedObjects else {
            return 0
        }
        return memories.count
    }

    /// Requests a fetch from the FRC.
    func requestFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
            // TODO: Error handling
        }
    }

    /// Returns a `ViewModel` corresponding to an index.
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
extension ArchiveViewModel: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                delegate?.insertNewMemoryAt(newIndexPath)
            }
        case .delete:
            if let newIndexPath = newIndexPath {
                delegate?.deleteMemoryAt(newIndexPath)
            }
        default:
            break
        }
    }
}
