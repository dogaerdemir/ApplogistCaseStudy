//
//  TotalPrice.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 9.04.2023.
//

import Foundation

struct Total {
    
    private static var price : Double = 0
    
    static func increaseTotalPrice(d:Double) {
        Total.price += d
    }

    static func decreaseTotalPrice(d:Double) {
        Total.price -= d
    }
    
    static func getPrice() -> Double {
        return Double(round(1000 * Total.price) / 1000)
    }
    
    static func resetPrice() {
        Total.price = 0
    }
}




