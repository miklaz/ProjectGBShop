//
//  LoginResult.swift
//  ProjectGBShop
//
//  Created by Михаил Зайцев on 26.12.2020.
//

import Foundation

// MARK: - LoginResult
struct LoginResult: Codable {
    let result: Int
    let user: User
    let authToken: String
}
