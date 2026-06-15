# SwiftCoreUtilities

A lightweight, performance-optimized, and compilation-safe Swift Package for iOS and macOS. Fully compliant with **Swift 6 Strict Concurrency**, `@MainActor` thread-safety, and optimized with module-inlining (`@inlinable`).

---

## 🛠 Features

- **Swift UI Toasts:** Easily display customizable toast notifications.
- **System Utilities:** Multi-platform `ReviewManager` for in-app reviews and App Store redirection.
- **Custom UI Components:** Fluid blur-background `CustomProgressView` and macOS-exclusive `CustomNavigationView`.
- **Performance Extensions:** Zero-overhead boilerplate extensions for `Array`, `CGFloat`, `Task`, and `UserDefaults`.

---

## 📦 Installation

In Xcode, go to **File > Add Package Dependencies...** and enter your repository URL:

```swift
    [https://github.com/YOUR_USERNAME/SwiftCoreUtilities.git](https://github.com/YOUR_USERNAME/SwiftCoreUtilities.git)
     
## 🚀 Usage Guide
     
     1. In-App Reviews & App Store Redirection (ReviewManager)
     A unified framework controller to safely handle native review requests or jump to the App Store page without layout deadlocks or multi-scene freeze traps.
     
     import SwiftCoreUtilities
     
     // Best Practice: Trigger automatically checks your UserDefaults flag condition
     ReviewManager.shared.requestInReviewAndStore(
                                                  storeLinkForReview: "[https://apps.apple.com/app/idYOUR_APP_ID](https://apps.apple.com/app/idYOUR_APP_ID)"
                                                  )
     
     // Force trigger native system dialog only
     ReviewManager.shared.inAppReview()
     
     // Reset for testing/debugging purposes
     ReviewManager.shared.clearAllUserDefaults()
     
     2. Custom Navigation Layout (macOS Exclusive)
     A thread-safe multi-column navigation layout tailored for modern macOS aesthetics with responsive sidebar constraints.
     
     import SwiftUI
     import SwiftCoreUtilities
     
     struct MainContentView: View {
        var body: some View {
            CustomNavigationView {
                Text("Sidebar Content") // Minimum: 200, Ideal: 220, Max: 300
            } detail: {
                Text("Main Detail View")
            }
        }
    }
     
     3. Custom Progress Indicator (CustomProgressView)
     A smooth material-blurred progress loader that adapts perfectly to dark and light mode rendering systems.
     
     import SwiftUI
     import SwiftCoreUtilities
     
     struct LoadingOverlay: View {
        var body: some View {
            // Defaults to size 32, cornerRadius 12
            CustomProgressView() 
            
            // Or fully customized size configuration
            CustomProgressView(size: 48, cornerRadius: 16)
        }
    }
     
     4. Native Engine Extensions
     🔹 Array Safety
     Returns a fallback array if the current instance is empty. Inlined (@inlinable) for native-like runtime efficiency.
     
     let items: [String] = []
     let activeList = items.ifEmpty(["Default Item"]) // Output: ["Default Item"]
     
     🔹 CGFloat Crash Prevention
     Guards layouts from unexpected mathematical glitches (NaN or Infinity) during dynamic scaling loops.
     
     let badCalculation: CGFloat = .nan
     let safeLayoutValue = badCalculation.safe // Output: 0.0 (Prevents rendering crashes)
     
     🔹 Async Task Delay Shortener
     Shorthand layout syntax to handle structural background context suspension.
     
     Task {
        try? await Task.sleep(seconds: 1.5) // Clean double parsing notation
        print("Executed safely after suspension")
    }
     
     🔹 Isolated UserDefaults Access
     Isolated properties to manage app review state parameters globally across module boundaries.
     
     // Get or Set globally inside your local applications safely
     let needsReview = UserDefaults.standard.inAppReview 
     UserDefaults.standard.inAppReview = false
     
     
     🔒 Swift 6 & Thread Safety
     Every component inside SwiftCoreUtilities is designed with cross-actor compilation constraints. The ReviewManager is constrained to the @MainActor with full Sendable guarantees to eliminate potential data races at build time.
