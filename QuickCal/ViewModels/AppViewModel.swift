//
//  AppViewModel.swift
//  QuickCal
//
//  Created by Adarsh on 5/7/25.
//

import SwiftUI
import Foundation
import FirebaseAuth

class AppViewModel: ObservableObject {
    @Published var isLoggedIn = false
    
    init() {
        let currentUser = Auth.auth().currentUser
        print("user at launch: \(String(describing: currentUser))")
        self.isLoggedIn = Auth.auth().currentUser != nil
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.isLoggedIn = user != nil
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Sign out failed: ", error.localizedDescription)
        }
    }
}
