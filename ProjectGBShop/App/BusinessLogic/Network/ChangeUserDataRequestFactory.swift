//
//  ChangeUserDataRequestFactory.swift
//  ProjectGBShop
//
//  Created by Михаил Зайцев on 26.12.2020.
//

import Foundation
import Alamofire

protocol ChangeUserDataRequestFactory {
    func doChange(login: String,
                  password: String,
                  firstName: String,
                  lastName: String?,
                  email: String,
                  completionHandler: @escaping (DataResponse<ChangeUserDataResult>) -> Void) -> Void
}
