//
//  ResponseCodable.swift
//  ProjectGBShop
//
//  Created by Михаил Зайцев on 26.12.2020.
//

import Foundation
import Alamofire

extension DataRequest {
    @discardableResult
    func responseCodable<T: Decodable> (
        errorParser: AbstractErrorParser,
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<T>) -> Void) -> Self
    {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            if let error = errorParser.parse(response: response, data: data, error: error) {
                return .failure(error)
            }
            
            let result = Request.serializeResponseData(response: response, data: data, error: error)
            
            switch result {
            case .success(let data):
                do {
                    let value = try JSONDecoder().decode(T.self, from: data)
                    return .success(value)
                } catch {
                    let customError = errorParser.parse(error)
                    return .failure(customError)
                }
            case .failure(let error):
                let customError = errorParser.parse(error)
                return .failure(customError)
            }
        }
        
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}
