//
//  MemoryViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 14/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

/// Responsible for providing a memory formatted data.
struct MemoryViewModel: Hashable {
    // MARK: - Properties
    let title: String
    let createdAt: Date
    let isActive: Bool
    let modifiedAt: Date
    let dueDate: Date

    // MARK: - Init
    init(title: String = "",
         createdAt: Date = Date(),
         isActive: Bool = false,
         modifiedAt: Date = Date(),
         dueDate: Date = Date()) {
        self.title = title
        self.createdAt = createdAt
        self.isActive = isActive
        self.modifiedAt = modifiedAt
        self.dueDate = dueDate
    }
}
