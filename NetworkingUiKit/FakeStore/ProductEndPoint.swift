//
//  ProductEndPoint.swift
//  NetworkingUiKit
//
//  Created by Akib Quraishi on 16/06/2024.
//

import Foundation


var environmentBaseURL : String {
    switch ProductNetworkManager.environment {
    case .production: return "https://fakestoreapi.com/"
    case .qa: return ""
    case .staging: return ""
    }
}


public enum ProductAPI {
    case getProducts
    case getProductByLimit(limit:Int)
}


extension ProductAPI:EndPointType {
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getProducts:
            return "products"
        case .getProductByLimit(_):
            return "products"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getProducts:
            return  .get
        case .getProductByLimit(_):
            return  .get
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getProducts:
            
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: nil)
        
        case .getProductByLimit(let limit):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["limit":"\(limit)"])
            
        default:
            return .request
         }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    
}
