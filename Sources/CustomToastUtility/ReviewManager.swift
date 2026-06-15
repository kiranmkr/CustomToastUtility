//
//  ReviewManager.swift
//  CustomToastUtility
//
//  Created by macpro on 15/06/2026.
//

import Foundation
import StoreKit
import SwiftUI

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

@MainActor
public final class ReviewManager: Sendable {
    
    // Public access for external project modules
    public static let shared = ReviewManager()
    
    private init() {}
    
    public func requestInReviewAndStore(storeLinkForReview: String) {
        if UserDefaults.standard.inAppReview {
            inAppReview()
        } else {
            openAppStorePage(appStoreLink: storeLinkForReview)
        }
    }
    
    @MainActor
    public func inAppReview() {
        if UserDefaults.standard.inAppReview {
            UserDefaults.standard.inAppReview = false
            
#if os(macOS)
            if #available(macOS 14.0, *) {
                let validWindow = NSApplication.shared.windows.first { $0.isKeyWindow && $0.contentViewController != nil }
                ?? NSApplication.shared.windows.first { $0.contentViewController != nil }
                
                if let rootVC = validWindow?.contentViewController {
                    AppStore.requestReview(in: rootVC)
                }
            } else {
                SKStoreReviewController.requestReview()
            }
#elseif os(iOS)
            let activeScene = UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first
            
            if let scene = activeScene {
                AppStore.requestReview(in: scene)
            }
#endif
        }
    }
    
    @MainActor
    public func openAppStorePage(appStoreLink: String) {
        guard let url = URL(string: appStoreLink) else { return }
        
#if os(macOS)
        NSWorkspace.shared.open(url)
#elseif os(iOS)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
#endif
    }
    
    public func clearAllUserDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
            UserDefaults.standard.synchronize()
            print("clear All UserDefaults")
        }
    }
    
}
