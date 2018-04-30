//
//  Extension.swift
//  apaetorres
//
//  Created by Arthur Rocha on 30/03/18.
//  Copyright © 2018 DatIn. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func hideHairline() {
        if let hairlineView: UIImageView = findHairlineImageView(containedIn: self) {
            hairlineView.isHidden = true
        }
    }
    
    func showHairline() {
        if let hairlineView: UIImageView = findHairlineImageView(containedIn: self) {
            hairlineView.isHidden = false
        }
    }
    
    private func findHairlineImageView(containedIn view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1.0 {
            return view as? UIImageView
        }
        
        for subview in view.subviews {
            if let imageView: UIImageView = findHairlineImageView(containedIn: subview ) {
                return imageView
            }
        }
        
        return nil
    }
}

extension UIColor {
    public convenience init?(hexString: String) {
        let alpha: Float = 1.0
        let scanner = Scanner(string:hexString)
        var color:UInt32 = 0;
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
        
        return
    }
}
