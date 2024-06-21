//
//  Router.swift
//  RandomUserApp
//
//  Created by Akib Quraishi on 14/06/2022.
//

import Foundation

public typealias NetworkRouterCompletion<T: Codable> = (Result<T, Error>) -> ()

//(_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request<T: Codable>(_ route: EndPoint, completion: @escaping NetworkRouterCompletion<T>)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request<T: Codable>(_ route: EndPoint, completion: @escaping NetworkRouterCompletion<T>) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                
                NetworkLogger.log(response: response as? HTTPURLResponse, data: data, error: error)
                //Http Status Code
                if let statusCode = response?.getStatusCode() {
                    print("Http Status Code: \(statusCode)")

                }
                
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(APIError.responseDataError))
                    return
                }
                
                
                
                /* Debug Data
                NSLog(#function + " 🔵 Output Raw Data Size \(request.url?.absoluteURL): \(data)")
                 let outputDataStr  = String(data: data, encoding: String.Encoding.utf8) as String?
                 NSLog(#function + " 🔵 Output String:\(String(describing: outputDataStr))")
                 */
                
                do {
                    let parsedObj = try JSONDecoder().decode(T.self, from: data)
                    print("🔴 parsedObj:", parsedObj)
                    completion(.success(parsedObj))
                    
                } catch let jsonErr {
                    print("🔴 Failed to decode json:", jsonErr)
                    completion(.failure(jsonErr))
                }
                
                
            })
        }catch let nError {
            completion(.failure(nError))
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
}


extension URLResponse {
    
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}


public enum APIError: Error {
    case unknownError
    case connectionError
    case invalidCredentials
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
    case unsuppotedURL
    case responseDataError
}
