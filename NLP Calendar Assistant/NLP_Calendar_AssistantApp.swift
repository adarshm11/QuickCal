import SwiftUI
import AppKit
import FirebaseCore
import FirebaseVertexAI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // We'll move Firebase initialization to the App struct
        print("App delegate launched")
    }
}

@main
struct NLP_Calendar_AssistantApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        // Initialize Firebase here, before any views are created
        FirebaseApp.configure()
        print("Firebase configured in App init")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
