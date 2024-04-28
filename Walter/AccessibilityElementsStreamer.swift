//
//  AccessibilityElementsStreamer.swift
//  Walter
//
//  Created by Patrick Botros on 4/24/24.
//

import Foundation
import AXSwift
import AppKit

class AccessibilityElementsStreamer {
    private var timer: Timer? = nil
    private var hasPresentedAccessibilityPermissionsRequestAlert = false
    // var elements: [TBD]? = nil
  
    static let shared = AccessibilityElementsStreamer()
    private init() {}
  
    func beginStreaming() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 2.0,
            repeats: true,
            block: { _ in
                guard UIElement.isProcessTrusted() else {
                    if !AccessibilityElementsStreamer.shared.hasPresentedAccessibilityPermissionsRequestAlert {
                        AccessibilityElementsStreamer.shared.presentAccessibilityPermissionsRequestAlert()
                        print(
                            """
                            In the accessibility permission system preference, navigate to
                            your 'DerivedData' directory (you can find this in your Xcode
                            location settings, but by default it will be at a path like
                            '/Users/pbotros/Library/Developer/Xcode/DerivedData', and find
                            the Walter application, which should be in a folder similar to
                            "Walter-abcdefgxyzmnopgzyxgjcihijkp/Build/Products/Debug".
                            """
                        )
                    }
                    return
                }
                AccessibilityElementsPrinter().printActiveApp()
            }
        )
    }
}

// MARK: - Permissions Management
extension AccessibilityElementsStreamer {
  private var hasAccessibilityPermissions: Bool {
    get {
      UIElement.isProcessTrusted(withPrompt: true)
    }
  }
  
  private func presentAccessibilityPermissionsRequestAlert() {
    let alert = NSAlert()
    alert.messageText = "Accessibility Permissions Required"
    alert.informativeText = "Please enable Walter to access Accessibility features."
    alert.addButton(withTitle: "Open System Preferences")
    alert.addButton(withTitle: "Cancel")
    let response = alert.runModal()
    
    self.hasPresentedAccessibilityPermissionsRequestAlert = true
    
    if response == .alertFirstButtonReturn {
      NSWorkspace.shared.open(.accessibilitySettingsURI)
    }
  }
}

class AccessibilityElementsPrinter {
    
    
    func printActiveApp() {
        if let application = NSWorkspace.shared.frontmostApplication {
            NSLog("localizedName: \(String(describing: application.localizedName)), processIdentifier: \(application.processIdentifier)")
            let uiApp = Application(application)!
            NSLog("windows: \(String(describing: try? uiApp.windows()))")
            do {
                NSLog("attributes: \(try uiApp.attributes())")
            } catch {
                print(error)
            }
            NSLog("at 0,0: \(String(describing: try? uiApp.elementAtPosition(0, 0)))")
            if let bundleIdentifier = application.bundleIdentifier {
                NSLog("bundleIdentifier: \(bundleIdentifier)")
                let windows = try? Application.allForBundleID(bundleIdentifier).first?.windows()
                NSLog("windows: \(String(describing: windows))")
            }
        }
    }
}
