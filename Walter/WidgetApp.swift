import SwiftUI

@main
struct WalterApp: WidgetApp {

  static func makeView() -> any View {
    return ContentView()
  }

}

protocol WidgetApp {
  static func main()
  static func makeView() -> any View
}

extension WidgetApp {

  static func main() {
    let contentView = makeView()
    let app = NSApplication.shared
    let delegate = AppDelegate(contentView: contentView)
    app.delegate = delegate
    
    let daemon = AccessibilityElementsStreamer.shared
    daemon.beginStreaming()

    _ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
  }

}
