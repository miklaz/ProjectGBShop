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


/*

import Foundation
import Alamofire

protocol AbstractRequestFactory {
    var errorParser: AbstractErrorParser { get }
    var sessionManager: Session { get }
    var queue: DispatchQueue { get }
    
    @discardableResult
    func request<T: Decodable>(
        request: URLRequestConvertible,
        completionHandler: @escaping (AFDataResponse<T>) -> Void)
    -> DataRequest
}

class CustomDecodableSerializer<T: Decodable>: DataResponseSerializerProtocol {
    private let errorParser: AbstractErrorParser
    
    init(errorParser: AbstractErrorParser) {
        self.errorParser = errorParser
    }
    
    func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) throws -> T {
        if let error = errorParser.parse(response: response, data: data, error: error) {
            throw error
        }
        do {
            let data = try DataResponseSerializer().serialize(request: request, response: response, data: data, error: error)
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            let customError = errorParser.parse(error)
            throw customError
        }
    }
}

extension DataRequest {
    @discardableResult
    func responseCodable<T: Decodable>(
        errorParser: AbstractErrorParser,
        queue: DispatchQueue = .main,
        completionHandler: @escaping (AFDataResponse<T>) -> Void)
    -> Self {
        let responseSerializer = CustomDecodableSerializer<T>(errorParser: errorParser)
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

extension AbstractRequestFactory {
    
    @discardableResult
    public func request<T: Decodable>(
        request: URLRequestConvertible,
        completionHandler: @escaping (AFDataResponse<T>) -> Void)
    -> DataRequest {
        return sessionManager
            .request(request)
            .responseCodable(errorParser: errorParser, queue: queue, completionHandler: completionHandler)
    }
}
*/
