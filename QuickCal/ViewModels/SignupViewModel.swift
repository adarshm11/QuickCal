//
//  SignupViewModel.swift
//  QuickCal
//
//  Created by Varun Valiveti on 5/7/25.
//

import Foundation
import Firebase
import FirebaseAuth



class SignupViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var responseMessage = ""
    
    func handleLogic(){
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let additionalUserInfo = authResult?.additionalUserInfo {
                print(additionalUserInfo)
            }
            print(error.debugDescription)
            if let errorDescription = error?.localizedDescription {
                self.responseMessage = errorDescription
            } else {
                self.responseMessage = "Account created!"
            }
            
            print(self.responseMessage)
        }
        
        
    }
}
