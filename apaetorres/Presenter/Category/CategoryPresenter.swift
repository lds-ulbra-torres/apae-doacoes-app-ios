//
//  CategoryPresenter.swift
//  apaetorres
//
//  Created by Arthur Rocha on 12/04/18.
//  Copyright © 2018 DatIn. All rights reserved.
//

import UIKit

protocol CategoryView: NSObjectProtocol {
    
    func startLoading()
    func finishLoading()
    func setCategories(categories: [CategoryViewData])
    func setEmptyCategories()
    func searchCategory(categories: [CategoryViewData])
    func error()
    
    func setBackgroundColorNavigation(hexString : String)
    func setBackgroundColorCollectionView(hexString: String)
    func setColorLargeTitle(color: UIColor)
    func setHairLine()
}

class CategoryPresenter {
    
    private let categoryService: CategoryService
    weak private var categoryView: CategoryView?
    
    init(service: CategoryService) {
        self.categoryService = service
    }
    
    func attachView(view: CategoryView) {
        categoryView = view
        setupView()
    }
    
    func detachView() {
        categoryView = nil
    }
    
    func setupView(){
        categoryView?.setBackgroundColorNavigation(hexString: "61B963")
        categoryView?.setBackgroundColorCollectionView(hexString: "F3F0E9")
        categoryView?.setColorLargeTitle(color: .white)
        categoryView?.setHairLine()
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
    
    func search(filter: String, categories: [CategoryViewData]){
        let searchPredicate = NSPredicate(format: "description CONTAINS[c] %@", filter,filter)
        let array = (categories as NSArray).filtered(using: searchPredicate)
        self.categoryView?.searchCategory(categories: array as! [CategoryViewData])
    }
}
