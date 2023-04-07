//
//  Model.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 7.04.2023.
//

import Foundation

struct FoodModel : Decodable {
    
    let id : String
    var name: String
    var price: Double
    var currency: String
    let imageUrl: String
    var stock: Int
    
    init(id : String, name: String, price: Double, currency: String, imageUrl : String, stock: Int) {
        self.id = id
        self.name = name
        self.price = price
        self.currency = currency
        self.imageUrl = imageUrl
        self.stock = stock
    }
     
}
