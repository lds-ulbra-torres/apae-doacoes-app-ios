//
//  CategoryLayout.swift
//  apaetorres
//
//  Created by Arthur Rocha on 13/04/18.
//  Copyright © 2018 DatIn. All rights reserved.
//

import UIKit

class CategoryLayout: UICollectionViewLayout {
    
    fileprivate var numberOfColums = 2
    
    fileprivate var contentHeight : CGFloat = 0
    
    fileprivate var contentWidth : CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    override func prepare() {
        
        let columnWidth = contentWidth / CGFloat(numberOfColums)
        print(columnWidth)
        
        self.contentHeight = contentHeight + percente(width: columnWidth, percente: 15)
        print(contentHeight)
    }
    
    func percente(width : CGFloat, percente : Int) -> CGFloat{
        return (width * CGFloat(percente)) / 100
    }
}
