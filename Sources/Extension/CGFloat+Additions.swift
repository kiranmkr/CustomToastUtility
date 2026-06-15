//
//  CGFloat+Additions.swift
//  SwiftCoreUtilities


import CoreGraphics

extension CGFloat {
    @inlinable
    public var safe: CGFloat {
        isFinite ? self : 0
    }
}
