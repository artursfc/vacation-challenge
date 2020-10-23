//
//  MemoryViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 14/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

/// Responsible for providing a memory formatted data.
struct MemoryViewModel {
    // MARK: - Properties
    let title: String
    let createdAt: String
    let isActive: Bool
    let modifiedAt: String
    let dueDate: String

    // MARK: - Init
    init(title: String = "",
         createdAt: Date = Date(),
         isActive: Bool = false,
         modifiedAt: Date = Date(),
         dueDate: Date = Date()) {
        self.title = title
        self.createdAt = createdAt.toBeDisplayedFormat()
        self.isActive = isActive
        self.modifiedAt = modifiedAt.toBeDisplayedFormat()
        self.dueDate = dueDate.toBeDisplayedFormat()
    }
}
