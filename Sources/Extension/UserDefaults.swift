//
//  UserDefaults.swift
//  SwiftCoreUtilities


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
