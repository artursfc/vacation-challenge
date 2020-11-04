//
//  UserDefaultsMock.swift
//  shirkers-challengeTests
//
//  Created by Artur Carneiro on 04/11/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

@testable import shirkers_challenge

final class UserDefaultsMock: UserDefaultsService {
    static let shared = UserDefaultsMock()

    var dict: [String: Any] = [:]

    private init() {

    }
    
    func object(forKey: String) -> Any? {
        return dict[forKey]
    }

    func setValue(_ value: Any?, forKey: String) {
        dict[forKey] = value
    }
}
