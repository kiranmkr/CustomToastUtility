//
//  ToastModifier.swift
//  CustomToastUtility
//
//  Created by macpro on 15/06/2026.
//

import SwiftUI

public struct ToastModifier: ViewModifier {
    @Binding var isShowing: Bool
    let message: String
    let type: ToastType
    
    @State private var toastTask: Task<Void, Never>? = nil
    
    public init(isShowing: Binding<Bool>, message: String, type: ToastType) {
        self._isShowing = isShowing
        self.message = message
        self.type = type
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if isShowing {
                    VStack {
                        Spacer()
                        HStack(spacing: 12) {
                            Image(systemName: type.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(type.color)
                            
                            Text(message)
                                .font(.system(size: 13, weight: .semibold, design: .default)) // Halka bold
                                .foregroundColor(type.color)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 24)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .padding(.bottom, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    .frame(maxWidth: .infinity)
                    .zIndex(100)
                    .onAppear {
                        startTimer()
                    }
                    .onDisappear {
                        toastTask?.cancel()
                        toastTask = nil
                    }
                }
            }
            .onDisappear {
                cancelTimer()
                if isShowing {
                    isShowing = false
                }
            }
            .onChange(of: isShowing) { newValue in
                if newValue {
                    startTimer()
                } else {
                    cancelTimer()
                }
            }
    }
    
    @MainActor
    func startTimer() {
        cancelTimer()
        toastTask = Task { @MainActor in
            try? await Task.sleep(seconds: 2.0)
            if !Task.isCancelled {
                await MainActor.run {
                    withAnimation(.spring()) {
                        isShowing = false
                    }
                }
            }
        }
    }
    
    @MainActor
    private func cancelTimer() {
        toastTask?.cancel()
        toastTask = nil
    }
}

extension View {
    public func customToast(isShowing: Binding<Bool>, message: String, type: ToastType) -> some View {
        self.modifier(ToastModifier(isShowing: isShowing, message: message, type: type))
    }
}

public enum ToastType: String, CaseIterable, Identifiable, Sendable {
    case success
    case error
    case info
    
    // SwiftUI dynamic lists optimization contract
    public var id: Self { self }
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .info: return .blue
        }
    }
}
