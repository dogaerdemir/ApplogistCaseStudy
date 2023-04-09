//
//  ViewModel.swift
//  CaseStudy
//
//  Created by Doğa Erdemir on 7.04.2023.
//

import Foundation
import Alamofire

class ViewModel {
    
    func fetchDataFromAPI(completion: @escaping (_ apiData:[FoodModel]) -> ()) {
        let url = "https://desolate-shelf-18786.herokuapp.com/list"
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { response in
            switch response.result {
                
                case .success(let data):
                    do {
                        let jsondata = try JSONDecoder().decode([FoodModel].self, from: data!)
                        completion(jsondata)
                    } catch {
                        print(error.localizedDescription)
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
            }

        }
    }
}

