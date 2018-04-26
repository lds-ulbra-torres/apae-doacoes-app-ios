//
//  CardCategoryPresenter.swift
//  apaetorres
//
//  Created by Arthur Rocha on 25/04/2018.
//  Copyright © 2018 DatIn. All rights reserved.
//

import UIKit

protocol CardCategoryView: class {
    func setTitle(text: String)
    func setBackgroundImage(url: URL)
}

class CardCategoryPresenter {
    private weak var view: CardCategoryView?
    private var categoryViewData: CategoryViewData?
    
    init() {}
    
    func attachView(categoryViewData: CategoryViewData, view: CardCategoryView){
        self.categoryViewData = categoryViewData
        self.view = view
        setupView()
    }
    
    private func setupView(){
        guard   let title = categoryViewData?.name,
            let photo = categoryViewData?.photo
            else {return}
        view?.setTitle(text: title)
        view?.setBackgroundImage(url: URL(string: photo)!)
    }
}
