//
//  RootView.swift
//  QuickCal
//
//  Created by Adarsh on 5/11/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appViewModel: AppViewModel

    var body: some View {
        if appViewModel.isLoggedIn {
            ChatView()
        } else {
            LoginView()
        }
    }
}

