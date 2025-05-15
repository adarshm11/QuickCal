//
//  LoginModel.swift
//  QuickCal
//
//  Created by Adarsh on 5/6/25.
//

struct User: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let success: Bool
    let message: String?
}
