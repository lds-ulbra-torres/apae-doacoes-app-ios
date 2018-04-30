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
    
    private let categoryPresenter       = CategoryPresenter(service: CategoryService())
    private let cardCategoryPresenter   = CardCategoryPresenter()
    var categoriesToDisplay             = [CategoryViewData]()
    var categoriesFilteredToDisplay     = [CategoryViewData]()
    var isLoading                       = false
    var isEmpty                         = false
    var isError                         = false
    let searchController                = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        customizeDZNEmptyDataSet()
        categoryPresenter.attachView(view: self)
        categoryPresenter.getCategories()
        self.collectionView!.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        categoryFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        self.collectionView?.collectionViewLayout = categoryFlowLayout
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func configureSearchController(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        let scb = searchController.searchBar
        scb.tintColor = UIColor.white
        scb.barTintColor = UIColor.white
        
        if let textfield = scb.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.blue
            if let backgroundview = textfield.subviews.first {
                backgroundview.backgroundColor = UIColor.white
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesFilteredToDisplay.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCell
        cell.layer.masksToBounds = true
        cell.backgroundColor = .white
        cardCategoryPresenter.attachView(categoryViewData: categoriesFilteredToDisplay[indexPath.row], view: cell)
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let padding: CGFloat =  60
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: (collectionViewSize/2), height: (collectionViewSize/2) + 25)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "customer", sender: nil)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.searchController.searchBar.resignFirstResponder()
    }
}

extension CategoryController : UISearchControllerDelegate ,UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if !(searchController.searchBar.text?.isEmpty)! {
            self.categoryPresenter.search(filter: searchController.searchBar.text!, categories: categoriesToDisplay)
        }
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        if (searchController.searchBar.text?.isEmpty)!{
            categoriesFilteredToDisplay = categoriesToDisplay
            self.collectionView?.reloadData()
        }
    }
}

// - MARK: CategoryView
extension CategoryController: CategoryView {
    func startLoading() {
        isLoading = true
    }
    
    func finishLoading() {
        isLoading = false
    }
    
    func setEmptyCategories() {
        categoriesToDisplay = []
        DispatchQueue.main.async { [unowned self] in
            self.collectionView?.reloadData()
        }
    }
    
    func setCategories(categories: [CategoryViewData]) {
        categoriesToDisplay = categories
        categoriesFilteredToDisplay = categories
        DispatchQueue.main.async { [unowned self] in
            self.collectionView?.reloadData()
        }
    }
    
    func searchCategory(categories: [CategoryViewData]) {
        categoriesFilteredToDisplay = categories
        DispatchQueue.main.async { [unowned self] in
            self.collectionView?.reloadData()
        }
    }
    
    func error() {
        isError = true
        DispatchQueue.main.async { [unowned self] in
            self.collectionView?.reloadData()
        }
    }
    
    func setBackgroundColorNavigation(hexString: String) {
        navigationController?.view.backgroundColor = UIColor(hexString: hexString)
    }
    
    func setBackgroundColorCollectionView(hexString: String) {
        collectionView?.backgroundColor = UIColor(hexString: hexString)
    }
    
    func setColorLargeTitle(color: UIColor) {
        self.navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedStringKey.foregroundColor: color
        ]
    }
    
    func setHairLine() {
        if let navigationController = self.navigationController, !navigationController.navigationBar.isHidden {
            navigationController.navigationBar.hideHairline()
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
