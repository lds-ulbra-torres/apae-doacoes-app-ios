//
//  CategoryController.swift
//  apaetorres
//
//  Created by Arthur Rocha on 30/03/18.
//  Copyright © 2018 DatIn. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import NVActivityIndicatorView

private let reuseIdentifier = "categoryCell"

class CategoryController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let categoryFlowLayout = UICollectionViewFlowLayout()
    
    private let categoryPresenter   = CategoryPresenter(service: CategoryService())
    var categoriesToDisplay         = [CategoryViewData]()
    var isLoading                   = false
    var isEmpty                     = false
    var isError                     = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeDZNEmptyDataSet()
        categoryPresenter.attachView(view: self)
        categoryPresenter.getCategories()
        
        self.navigationController?.view.backgroundColor = UIColor(hexString: "61B963")
        
        if let navigationController = self.navigationController, !navigationController.navigationBar.isHidden {
            navigationController.navigationBar.hideHairline()
        }
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedStringKey.foregroundColor: UIColor.white
            ]
        }
        self.collectionView!.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        categoryFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        categoryFlowLayout.headerReferenceSize = CGSize(width: (collectionView?.frame.width)!, height: 54)
        
        self.collectionView?.collectionViewLayout = categoryFlowLayout
        
        self.collectionView?.backgroundColor = UIColor(hexString: "F3F0E9")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return categoriesToDisplay.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        cell.layer.masksToBounds = true
        cell.backgroundColor = .white
        cell.backgroundImage.image = #imageLiteral(resourceName: "farmacia")
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader", for: indexPath) as! SearchCollectionReusableView
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let padding: CGFloat =  60
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: (collectionViewSize/2), height: (collectionViewSize/2) + 25)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "customer", sender: nil)
    }
}

extension CategoryController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
//            self.collectionView?.reloadData()
        }
        print(searchText)
    }
}

// - MARK: CategoryView
extension CategoryController: CategoryView {
    func startLoading() {
        print("Starting...")
        isLoading = true
    }
    
    func finishLoading() {
        print("Finishing!")
        isLoading = false
    }
    
    func setEmptyCategories() {
        print("Set empty categories")
        categoriesToDisplay = []
        DispatchQueue.main.async { [unowned self] in
            self.collectionView?.reloadData()
        }
    }
    
    func setCategories(categories: [CategoryViewData]) {
        categoriesToDisplay = categories
        DispatchQueue.main.async { [unowned self] in
            self.collectionView?.reloadData()
        }
    }
    
    func error() {
        print("Error no server")
        isError = true
        DispatchQueue.main.async { [unowned self] in
            self.collectionView?.reloadData()
        }
    }
}

// MARK: DZNEmptyDataSet & NVActivityIndicatorView
extension CategoryController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    func customizeDZNEmptyDataSet() {
        collectionView?.emptyDataSetSource = self
        collectionView?.emptyDataSetDelegate = self
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        if isLoading {
            return nil
        }
        
        if isError {
            return NSAttributedString(string: "Não foi possível comunicar com o servidor. Verifique sua conexão com a internet ou tente novamente mais tarde!", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
        }
        
        return NSAttributedString(string: "Nenhuma categoria encontrada", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        if isLoading {
            return nil
        }
        
        if isError {
            return #imageLiteral(resourceName: "ic_error")
        }
        
        return #imageLiteral(resourceName: "ic_hourglass_empty")
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        if isLoading {
            return UIView().activityIndicatorViewCustom(bounds: self.view.bounds.width)
        }
        return nil
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
