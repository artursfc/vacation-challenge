//
//  MemoryContextViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 21/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import CoreData
import os.log

// MARK: - Protocol-delegate
protocol MemoryContextViewModelDelegate: AnyObject {
    func didUpdateNewDueDate()
}

final class MemoryContextViewModel {
    // MARK: - Properties
    private let context: NSManagedObjectContext

    weak var delegate: MemoryContextViewModelDelegate?

    // MARK: - Init
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    // MARK: - FileManager
    /// Removes file representing a memory's audio.
    private func remove(file: String, at fileManager: FileManager = FileManager.default) {
        let url = fileManager.userDocumentDirectory
        let fileURL = url.appendingPathComponent("\(file).m4a")
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            os_log("RecorderViewModel failed to remove a memory's file.", log: .appFlow, type: .error)
        }
    }
}
