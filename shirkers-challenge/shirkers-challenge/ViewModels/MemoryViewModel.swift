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
         createdAt: String = "",
         isActive: Bool = false,
         modifiedAt: String = "",
         period: String = "") {
        self.title = title
        self.createdAt = createdAt
        self.isActive = isActive
        self.modifiedAt = modifiedAt
        self.dueDate = period
    }
}
