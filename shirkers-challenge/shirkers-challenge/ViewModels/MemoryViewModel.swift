//
//  MemoryViewModel.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 14/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

struct MemoryViewModel {
    let title: String
    let createdAt: String
    let isActive: Bool
    let modifiedAt: String
    let period: String

    init(title: String = "",
         createdAt: String = "",
         isActive: Bool = false,
         modifiedAt: String = "",
         period: String = "") {
        self.title = title
        self.createdAt = createdAt
        self.isActive = isActive
        self.modifiedAt = modifiedAt
        self.period = period
    }
}
