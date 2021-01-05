//
//  AuthRequestFactory.swift
//  ProjectGBShop
//
//  Created by Михаил Зайцев on 26.12.2020.
//

import Foundation
import Alamofire

protocol AuthRequestFactory {
    func login(userName: String, password: String, completionHandler: @escaping (Alamofire.DataResponse<LoginResult>) -> Void)
    func logout(completionHandler: @escaping (DataResponse<LogoutResult>) -> Void)
}


