//
//  BaseStudentInformationViewController.swift
//  On The Map
//
//  Created by SoSucesso on 29/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//
import Foundation
import UIKit

class BaseStudentInformationViewController : UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        HomeViewController.addRefreshListener(object: self, selector: #selector(onRefreshed))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        HomeViewController.removeRefreshListener(object: self)
    }
    
    func onRefreshed() {
        print(StudentManager.sharedInstance().infoArray.count)
    }
    
}
