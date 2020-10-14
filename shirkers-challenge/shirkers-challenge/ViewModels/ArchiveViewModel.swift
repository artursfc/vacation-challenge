//
//  ArchiveViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 13/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import CoreData

protocol ArchiveViewModelDelegate: AnyObject {
    func beginUpdate()
    func insertNewEntryAt(_ index: IndexPath)
    func endUpdate()
}

final class ArchiveViewModel: NSObject {
    // MARK: - Properties
    private let context: NSManagedObjectContext

    private(set) lazy var fetchedResultsController: NSFetchedResultsController<Recording> = {
        let fetchRequest: NSFetchRequest<Recording> = Recording.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Recording.modifiedAt, ascending: false)]

        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: self.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self

        return frc
    }()

    weak var delegate: ArchiveViewModelDelegate?

    // MARK: - Init
    init(context: NSManagedObjectContext) {
        self.context = context
    }

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
            // TODO: Error handling
        }
    }

    func viewModelAt(index: IndexPath) -> ArchiveTableViewCellViewModel {
        let memory = fetchedResultsController.object(at: index)

        guard let title = memory.title,
              let createdAt = memory.createdAt?.stringFormatted(),
              let modifiedAt = memory.modifiedAt?.stringFormatted(),
              let period = memory.period?.stringFormatted() else {
            return ArchiveTableViewCellViewModel()
        }

        return ArchiveTableViewCellViewModel(title: title,
                                             createdAt: createdAt,
                                             isActive: memory.isActive,
                                             modifiedAt: modifiedAt,
                                             period: period)
    }

}

// MARK: - FRC Delegate
extension ArchiveViewModel: NSFetchedResultsControllerDelegate {

}
