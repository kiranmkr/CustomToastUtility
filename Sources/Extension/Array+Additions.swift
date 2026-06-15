//
//  Array+Additions.swift
//  SwiftCoreUtilities


import Foundation

extension Array {
    @inlinable
    public func ifEmpty(_ fallback: [Element]) -> [Element] {
        isEmpty ? fallback : self
    }
}
