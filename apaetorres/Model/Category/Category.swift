//
//  Category.swift
//  apaetorres
//
//  Created by Arthur Rocha on 12/04/18.
//  Copyright © 2018 DatIn. All rights reserved.
//

import Foundation

struct Category: Decodable {
    
    var id_category: String?
    var name_category: String?
    var description_category: String?
    var photo_category: String?
    
}

struct CategoryKey: Decodable {
    let category: [Category]
}
