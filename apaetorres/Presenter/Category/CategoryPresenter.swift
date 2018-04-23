//
//  CategoryPresenter.swift
//  apaetorres
//
//  Created by Arthur Rocha on 12/04/18.
//  Copyright © 2018 DatIn. All rights reserved.
//

import Foundation

class CategoryPresenter {
    
    private let categoryService: CategoryService
    weak private var categoryView: CategoryView?
    
    init(service: CategoryService) {
        self.categoryService = service
    }
    
    func attachView(view: CategoryView) {
        categoryView = view
    }
    
    func detachView() {
        categoryView = nil
    }
    
    func getCategories() {
        
        self.categoryView?.startLoading()
        categoryService.getCategories { [weak self] data in
            self?.categoryView?.finishLoading()
            guard let categories = data else {
                self?.categoryView?.error()
                return
            }
            
            if categories.count == 0 {
                self?.categoryView?.setEmptyCategories()
            }else{
                let mappedCategories = categories.map({ category in
                    return CategoryViewData(id: category.id_category!, name: category.name_category!, description: category.description_category!, photo: category.photo_category!)
                })
                self?.categoryView?.setCategories(categories: mappedCategories)
            }
        }
    }
}
