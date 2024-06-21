//
//  ViewController.swift
//  NetworkingUiKit
//
//  Created by Akib Quraishi on 09/06/2024.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let productNM = ProductNetworkManager()
        
//        productNM.getProducts { products, error in
//            
//            if let products = products {
//                print("🔵🔵🔵 \(products.count) 🔵🔵🔵")
//            }
//            
//            if let error = error{
//                print("🔵🔵🔵Error: \(error) 🔵🔵🔵")
//            }
//        }
        
        productNM.getProductsbyLimit(limit: 5){ products, error in
            
            if let products = products {
               // print("🔵🔵🔵 \(products.count) 🔵🔵🔵")
            }
            
            if let error = error{
                //print("🔵🔵🔵Error: \(error) 🔵🔵🔵")
            }
        }
        
        
    }


}

