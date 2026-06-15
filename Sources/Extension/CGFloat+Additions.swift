//
//  CGFloat+Additions.swift
//  CustomToastUtility
//
//  Created by macpro on 15/06/2026.
//

import CoreGraphics

extension CGFloat {
    @inlinable
    public var safe: CGFloat {
        isFinite ? self : 0
    }
}
