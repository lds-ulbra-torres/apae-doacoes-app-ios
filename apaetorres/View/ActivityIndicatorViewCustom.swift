//
//  ActivityIndicatorViewCustom.swift
//  apaetorres
//
//  Created by Arthur Rocha on 22/04/2018.
//  Copyright © 2018 DatIn. All rights reserved.
//

import Foundation
import NVActivityIndicatorView

extension UIView {
    func activityIndicatorViewCustom(bounds : CGFloat) -> UIView {
        let size: CGFloat = 64
        let x = (bounds - size) / 2
        let y: CGFloat = 0
        let loadingView = UIView(frame: CGRect(x: x, y: y, width: size, height: size))
        let activityIndicatorView = NVActivityIndicatorView(frame: loadingView.frame, type: NVActivityIndicatorType.ballRotateChase, color: nil, padding: nil)
        activityIndicatorView.center = loadingView.center
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        loadingView.addSubview(activityIndicatorView)
        return loadingView
    }
}
