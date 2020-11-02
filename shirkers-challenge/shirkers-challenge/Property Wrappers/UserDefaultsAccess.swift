//
//  UserDefaultsAccess.swift
//  shirkers-challenge
//
//  Created by Artur Carneiro on 12/10/20.
//  Copyright © 2020 Artur Carneiro. All rights reserved.
//

import Foundation

/// Responsible for providing convinient and type-safe access to `UserDefaults`.
/// It is initialized with `UserDefaults.standard` as default. When testing, mock
/// `UserDefaults` through the `UserDefaultsService` protocol.
@propertyWrapper struct UserDefaultsAccess<T> {
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaultsService

    /// Initializes a new instance of this type.
    ///
    /// - Parameter key: The key being accessed.
    /// - Parameter defaultValeu: The default value given to the key.
    /// - Parameter userDefaults: The instance of `UserDefaultsService`. Defaults to
    /// `UserDefaults.standard`
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

/// The service responsible for providing access to `UserDefaults`.
protocol UserDefaultsService {
    func object(forKey: String) -> Any?
    func setValue(_ value: Any?, forKey: String)
}

extension UserDefaults: UserDefaultsService {}
