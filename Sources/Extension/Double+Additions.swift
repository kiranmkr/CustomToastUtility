//
//  Double+Additions.swift
//  SwiftCoreUtilities
//
//  Created by macpro on 16/07/2026.
//

import Foundation

extension Double {
    
    @inlinable
    public var formattedPrice: String {
        return String(format: "%.2f", self)
    }
    
    @inlinable
    public func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
