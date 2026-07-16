//
//  CustomNavigationView.swift
//  SwiftCoreUtilities


#if os(macOS)
import SwiftUI
import AppKit

public struct CustomNavigationView<Sidebar: View, Detail: View>: View {
    
    public let sidebar: Sidebar
    public let detail: Detail
    public let size: CGFloat

    @inlinable
    public init(@ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail, size: CGFloat = 200) {
        self.sidebar = sidebar()
        self.detail = detail()
        self.size = size
    }
    
    public var body: some View {
        
        let safeSize = (size.isFinite && size > 0) ? size : 200
        
        if #available(macOS 13.0, *) {
            NavigationSplitView {
                sidebar
                    .navigationSplitViewColumnWidth(min: safeSize, ideal: safeSize, max: safeSize)
                
            } detail: {
                detail
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            NavigationView {
                sidebar
                    .toolbar {
                        ToolbarItem {
                            Button(action: {
                                toggleSidebar()
                            }) {
                                Image(systemName: "sidebar.left")
                            }
                        }
                        
                    }
                
                detail
            }
            .navigationViewStyle(.columns)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
    }
    
    @MainActor
    private func toggleSidebar() {
        Task { @MainActor in
            NSApp.keyWindow?
                .firstResponder?
                .tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        }
    }
    
}
#endif
