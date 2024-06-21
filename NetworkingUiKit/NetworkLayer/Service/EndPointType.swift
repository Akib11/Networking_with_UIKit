//
//  EndPointType.swift
//  RandomUserApp
//
//  Created by Akib Quraishi on 13/06/2022.
//

import Foundation


protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
