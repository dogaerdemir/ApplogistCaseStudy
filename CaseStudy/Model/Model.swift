//
//  Model.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 7.04.2023.
//

import Foundation
import Alamofire

// MARK: - Food
struct FoodModel: Codable {
    let id, name: String
    let price: Double
    let currency: String
    let imageUrl: String
    let stock: Int
}
