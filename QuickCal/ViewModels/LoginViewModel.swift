//
//  LoginViewModel.swift
//  QuickCal
//
//  Created by Adarsh on 5/6/25.
//

import Foundation
import Firebase
import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var responseMessage = ""
    
    func handleLogin(appViewModel: AppViewModel) {

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let authResult = authResult {
                print(authResult)
                DispatchQueue.main.async {
                    appViewModel.isLoggedIn = true
                }
            }
            self.responseMessage = authResult != nil ? "Logged in" : "Login failed, please try again"
            if let errorDescription = error?.localizedDescription {
                print(errorDescription)
            }
        }
    }
    
}
