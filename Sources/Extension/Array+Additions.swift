//
//  Array+Additions.swift
//  CustomToastUtility
//
//  Created by macpro on 15/06/2026.
//

import Foundation

extension Array {
    @inlinable
    public func ifEmpty(_ fallback: [Element]) -> [Element] {
        isEmpty ? fallback : self
    }
}
