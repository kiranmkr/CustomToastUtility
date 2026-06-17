//
//  FileDownloader.swift
//  SwiftCoreUtilities
//
//  Created by macpro on 17/06/2026.
//

import Foundation
import UniformTypeIdentifiers

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public struct FileDownloader {
    
    public static func downloadAndSaveFile(url: URL, fileName: String) async -> URL? {
        do {
            let (tempLocalURL, response) = try await URLSession.shared.download(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return nil
            }
            
            // Temporary directory
            let fileManager = FileManager.default
            let tempDir = fileManager.temporaryDirectory.appendingPathComponent("TempFolder", isDirectory: true)
            
            try fileManager.createDirectory(at: tempDir, withIntermediateDirectories: true)
            
            let destinationURL = tempDir.appendingPathComponent(fileName)
            
            if fileManager.fileExists(atPath: destinationURL.path) {
                try? fileManager.removeItem(at: destinationURL)
            }
            
            try fileManager.moveItem(at: tempLocalURL, to: destinationURL)
            
            print("✅ File successfully saved at: \(destinationURL.path)")
            
            return destinationURL
            
        } catch {
            print("❌ Download error: \(error.localizedDescription)")
            return nil
        }
    }
    
#if os(macOS)
    @MainActor
    public static func presentSavePanelForImage(
        fileURL: URL
    ) async {
        
        // 1. Load internal image data
        guard let imageData = try? Data(contentsOf: fileURL) else {
            print("❌ Failed to read internal image")
            return
        }
        
        // 2. Configure save panel
        let panel = NSSavePanel()
        panel.title = String(localized: "Save your file")
        panel.nameFieldStringValue = fileURL.lastPathComponent
        panel.allowedContentTypes = [.item]
        panel.canCreateDirectories = true
        panel.isExtensionHidden = false
        
        // 3. Present panel using async continuation
        let destinationURL: URL? = await withCheckedContinuation { continuation in
            panel.begin { response in
                guard response == .OK else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: panel.url)
            }
        }
        
        // 4. Write file if user selected a location
        guard let destinationURL else {
            print("❌ User cancelled save panel")
            return
        }
        
        do {
            try imageData.write(to: destinationURL, options: .atomic)
            print("✅ Image saved at:", destinationURL.path)
        } catch {
            print("❌ Failed to save image:", error)
        }
    }
    
#endif
    
    @MainActor
    public static func share(fileURL: URL) {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("❌ File does not exist to share")
            return
        }
        
#if os(macOS)
        
        let picker = NSSharingServicePicker(items: [fileURL])
        if let keyWindow = NSApplication.shared.keyWindow,
           let contentView = keyWindow.contentView {
            picker.show(
                relativeTo: contentView.bounds,
                of: contentView,
                preferredEdge: .maxY
            )
        }
        
#elseif os(iOS)
        let activityVC = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        
        if let rootVC = UIApplication.shared.connectedScenes
            .flatMap({ ($0 as? UIWindowScene)?.windows ?? [] })
            .first(where: { $0.isKeyWindow })?.rootViewController {
            
            if let popoverController = activityVC.popoverPresentationController {
                popoverController.sourceView = rootVC.view
                popoverController.sourceRect = CGRect(x: rootVC.view.bounds.midX, y: rootVC.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            rootVC.present(activityVC, animated: true, completion: nil)
        }
#endif
    }
    
}
