//
//  SignupModel.swift
//  QuickCal
//
//  Created by Varun Valiveti on 5/7/25.
//

struct NewUserInfo{
    let email: String
    let password: String
}

struct SignupResponse{
    let success: Bool
    let response: String?
}
