//
//  CategoryViewData.swift
//  apaetorres
//
//  Created by Arthur Rocha on 12/04/18.
//  Copyright © 2018 DatIn. All rights reserved.
//

import Foundation

struct CategoryViewData {
    let id: String?
    let name: String?
    let description: String?
    let photo: String?
    
    init(id: String, name: String, description: String, photo: String) {
        self.id = id
        self.name = name
        self.description = description
        self.photo = "http://apaetorres.org.br/doacoes\(photo)"
    }
}
