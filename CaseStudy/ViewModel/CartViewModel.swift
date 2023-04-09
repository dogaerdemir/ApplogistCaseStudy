//
//  CartViewModel.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 7.04.2023.
//

import Foundation

class CartViewModel {
    
    func resetCurrentCounts(dataStr : [FoodModel]) {
        dataStr.forEach { foodModel in
            foodModel.currentCount = 0
        }
    }
    
    func sendProducts(dataStr:[FoodModel], handler:@escaping(_ result:Order)->Void) {
        var dict = [FoodModel:Int]()
        
        for food in dataStr {
            dict[food] = food.currentCount
        }

        let data = createJson(shoppingCart: dict)!
        
        let url = URL(string: "https://desolate-shelf-18786.herokuapp.com/checkout")!
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }

            do {
                let finalResult = try JSONDecoder.init().decode(Order.self, from: data)
                handler(finalResult)
            } catch {
                
            }
        }
        task.resume()
    }
        
    private func createJson(shoppingCart:[FoodModel:Int]) -> Data?{
        let products = Array(shoppingCart.keys)
        let amounts = Array(shoppingCart.values)
        
        var informations:[[String:Any]] = []
        
        for index in 0..<products.count {
            let dict = ["id":products[index].id,"amount":amounts[index]] as [String : Any]
            informations.append(dict)
        }
        
        let body = try? JSONSerialization.data(withJSONObject: ["products":informations], options: [])
        return body
    }
}
