//
//  ProductNetworkManager.swift
//  NetworkingUiKit
//
//  Created by Akib Quraishi on 16/06/2024.
//

import Foundation

// MARK: - Welcome
struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description, category: String
    let image: String
    let rating: Rating
   
}

// MARK: - Rating
struct Rating: Codable {
    let rate: Double
    let count: Int
}

struct ProductNetworkManager {
    
    static let environment : NetworkEnvironment = .production
    
    let router = Router<ProductAPI>()
    
    func getProducts(completion: @escaping (_ products: [Product]?,_ error: String?)->()){
        
        router.request(.getProducts) { (result : Result <[Product], Error>) in
            
            switch result {
            
            case .failure(let error):
                completion(nil, error.localizedDescription)
               
            case .success(let productArray):
                
//                if let postError = productArray.error {
//                    print("🔵🔵🔵 \(postError) 🔵🔵🔵")
//                    completion(nil,postError)
//                }
                
        
                    //print("🔵🔵🔵 \(productArray.count) 🔵🔵🔵")
                    completion(productArray,nil)
                
                
            }

            
            
        }
        
        
    }
    
    
    func getProductsbyLimit(limit: Int, completion: @escaping (_ products: [Product]?,_ error: String?)->()){
        
        router.request(.getProductByLimit(limit: 5)) { (result : Result <[Product], Error>) in
            
            switch result {
            
            case .failure(let error):
                completion(nil, error.localizedDescription)
               
            case .success(let productArray):
                completion(productArray,nil)
                
            }
        }
        
    }
    
    
}



