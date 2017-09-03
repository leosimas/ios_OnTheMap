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
        print(StudentData.sharedInstance().infoArray.count)
    }
    
    internal func openUrl(studentInformation : StudentInformation) {
        func showError() {
            Dialogs.alert(controller: self, title: "Sorry :(", message: "Couldn't open this URL : \(studentInformation.mediaURL)")
        }
        
        guard let url = URL(string: studentInformation.mediaURL) else {
            showError()
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showError()
        }
    }
    
}
