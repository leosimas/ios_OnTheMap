//
//  LoadingView.swift
//  On The Map
//
//  Created by SoSucesso on 02/09/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class LoadingView {
    
    private static var loadingView : UIView?
    private static var activityIndicator : UIActivityIndicatorView?
    
    private init() {}
    
    private static func getView() -> UIView {
        if (loadingView != nil) {
            return loadingView!
        }
        loadingView = UIView()
        
        let view = loadingView!
        view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        view.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        view.clipsToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator!.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.height / 2)
        activityIndicator!.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        activityIndicator!.startAnimating()
        
        view.addSubview(activityIndicator!)
        
        return loadingView!
    }
    
    static func show(inView view : UIView) {
        LoadingView.hide()
        
        DispatchQueue.main.async {
            let loadingView = LoadingView.getView()
            loadingView.center = view.center
            view.addSubview(loadingView)
        }
        
        
    }
    
    static func hide() {
        guard let view = LoadingView.loadingView else {
            return
        }
        
        DispatchQueue.main.async {
            view.removeFromSuperview()
        }
    }
    
}
