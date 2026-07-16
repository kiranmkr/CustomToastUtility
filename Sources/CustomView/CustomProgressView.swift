//
//  File.swift
//  SwiftCoreUtilities


import SwiftUI

public struct CustomProgressView: View {
    
    private static let defaultSize: CGFloat = 32
    private static let padding: CGFloat = 16
    
    public let size: CGFloat
    public let cornerRadius: CGFloat
    
    private var safeSize: CGFloat {
        (size.isFinite && size > 0) ? size : Self.defaultSize
    }
    
    private var totalSize: CGFloat {
        safeSize + Self.padding
    }
    
    @inlinable
    public init(size: CGFloat = 32, cornerRadius: CGFloat = 12) {
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        
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
