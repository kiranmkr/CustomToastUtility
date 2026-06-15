//
//  File.swift
//  CustomToastUtility
//
//  Created by macpro on 15/06/2026.
//

import SwiftUI

public struct CustomProgressView: View {
    
    public let size: CGFloat
    public let cornerRadius: CGFloat
    
    @inlinable
    public init(size: CGFloat = 32, cornerRadius: CGFloat = 12) {
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        let totalSize = size.isFinite ? (size + 16) : 48
        let safeSize = size.isFinite ? size : 32
        
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial)
                .frame(width: totalSize, height: totalSize)
            
            ProgressView()
                .frame(width: safeSize, height: safeSize)
                .tint(.primary)
        }
        .frame(width: totalSize, height: totalSize)
    }
}
