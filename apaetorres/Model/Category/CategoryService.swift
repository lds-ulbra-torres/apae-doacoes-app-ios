//
//  CategoryService.swift
//  apaetorres
//
//  Created by Arthur Rocha on 21/04/2018.
//  Copyright © 2018 DatIn. All rights reserved.
//

import Foundation
import UIKit

class CategoryService {
    
    func getCategories(cb: @escaping ([Category]?)-> Void){
        
        guard let url = URL(string: "http://apaetorres.org.br/doacoes/api/category") else
        { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if err != nil{
                cb(nil)
            }
            
            guard let data = data else {
                cb(nil)
                return
            }
            
            do{
                let response = try JSONDecoder().decode(CategoryKey.self, from: data)
                var categories = [Category]()
                
                if response.category.count > 0 {
                    response.category.forEach({ (category) in
                        categories.append(category)
                    })
                    cb(categories)
                }else{
                    cb(categories)
                }
            }catch let jsonErr {
                print(jsonErr)
                cb(nil)
            }
        }.resume()
        
    }
    
}
