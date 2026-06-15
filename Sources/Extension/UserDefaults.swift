//
//  UserDefaults.swift
//  CustomToastUtility
//
//  Created by macpro on 15/06/2026.
//

import Foundation

extension UserDefaults {
    @inlinable
    public var inAppReview: Bool {
        get {
            return object(forKey: "com.library.storage.inAppReview") as? Bool ?? true
        }
        set {
            set(newValue, forKey: "com.library.storage.inAppReview")
        }
    }
}
