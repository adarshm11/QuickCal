//
//  QuickCalApp.swift
//  QuickCal
//
//  Created by Varun Valiveti on 4/25/25.
//

import SwiftUI
import FirebaseCore

@main
struct QuickCalApp: App {
    
    @StateObject var appViewModel = AppViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        
        MenuBarExtra("QuickCal", systemImage: "calendar") {
            RootView()
                .environmentObject(appViewModel)
                .frame(width: 400, height: 500)
        }
        .menuBarExtraStyle(.window)
    }
}
