//
//  CustomNavigationView.swift
//  SwiftCoreUtilities


#if os(macOS)
import SwiftUI
import AppKit

public struct CustomNavigationView<Sidebar: View, Detail: View>: View {
    
    public let sidebar: Sidebar
    public let detail: Detail
    
    @inlinable
    public init(@ViewBuilder sidebar: () -> Sidebar, @ViewBuilder detail: () -> Detail) {
        self.sidebar = sidebar()
        self.detail = detail()
    }
    
    public var body: some View {
        
        if #available(macOS 13.0, *) {
            NavigationSplitView {
                sidebar
                    .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: 200)
                
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
