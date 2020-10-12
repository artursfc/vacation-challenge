//
//  UserDefaultsAccess.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 12/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

@propertyWrapper struct UserDefaultsAccess<T> {
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaultsService

    init(key: String,
         defaultValue: T,
         userDefaults: UserDefaultsService = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults.setValue(newValue, forKey: key)
        }
    }

}

protocol UserDefaultsService {
    func object(forKey: String) -> Any?
    func setValue(_ value: Any?, forKey: String)
}

extension UserDefaults: UserDefaultsService {}
