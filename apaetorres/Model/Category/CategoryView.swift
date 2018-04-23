//
//  CategoryView.swift
//  apaetorres
//
//  Created by Arthur Rocha on 12/04/18.
//  Copyright © 2018 DatIn. All rights reserved.
//

import Foundation

protocol CategoryView: NSObjectProtocol {
    
    func startLoading()
    func finishLoading()
    func setCategories(categories: [CategoryViewData])
    func setEmptyCategories()
    func error()
    
}
