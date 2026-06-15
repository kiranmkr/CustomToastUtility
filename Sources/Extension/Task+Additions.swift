//
//  File.swift
//  CustomToastUtility
//
//  Created by macpro on 15/06/2026.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    public static func sleep(seconds: Double) async throws {
        let body: @Sendable () async throws -> Void = { [seconds] in
            if #available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *) {
                try await Task.sleep(for: .seconds(seconds))
            } else {
                let nanoseconds = UInt64(seconds * 1_000_000_000)
                try await Task.sleep(nanoseconds: nanoseconds)
            }
        }
        try await body()
    }
}
