//
//  Model.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 7.04.2023.
//

import Foundation
import Alamofire

class FoodModel: Codable, Hashable {
    
    static func == (lhs: FoodModel, rhs: FoodModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
    }
    
    let id, name: String
    let price: Double
    let currency: String
    let imageUrl: String
    let stock: Int
    var currentCount = 0

    enum CodingKeys: String, CodingKey {
        case id, name, price, currency, imageUrl, stock
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        price = try container.decode(Double.self, forKey: .price)
        currency = try container.decode(String.self, forKey: .currency)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        stock = try container.decode(Int.self, forKey: .stock)
        
    }
    
    func increaseCurrentCount() {
        if currentCount < stock {
            self.currentCount += 1
        }
    }
    
    func decreaseCurrentCount() {
        if currentCount > 0 {
            self.currentCount -= 1
        }
    }
}

