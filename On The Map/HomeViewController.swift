//
//  HomeViewController.swift
//  On The Map
//
//  Created by SoSucesso on 27/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {
    
    static let REFRESH_NOTIFICATION = "REFRESH_NOTIFICATION"

    @IBOutlet weak var updateLocationButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshStudentsData()
        refreshCurrentStudentData()
    }
    
    @IBAction func logoutPressed() {
        Dialogs.confirm(controller: self, title: "Logout", message: "Are you sure?") { (confirmed) in
            if !confirmed {
                return
            }
            
            LoadingView.show(inView: self.selectedViewController!.view)
            
            UdacityClient.sharedInstance().requestLogout { (sucess, error) in
                LoadingView.hide()
                
                if !sucess {
                    Dialogs.alert(controller: self, title: "Error", message: error!.localizedDescription)
                    return
                }
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func refresh() {
        refreshStudentsData()
    }
    
    @IBAction func updateLocation() {
        if StudentManager.sharedInstance().studentLastInfo == nil {
            displayEnterLocation()
            return
        }
        
        Dialogs.confirm(controller: self, title: "", message: "You have already posted a location. Would you like to overwrite it?") { (confirmed) in
            if confirmed {
                self.displayEnterLocation()
            }
        }
        
    }
    
    private func displayEnterLocation() {
        let enterVC = storyboard?.instantiateViewController(withIdentifier: "EnterLocationViewController") as! EnterLocationViewController
        present(enterVC, animated: true, completion: nil)
    }
    
    private func refreshStudentsData() {
        if self.selectedViewController != nil {
            LoadingView.show(inView: self.selectedViewController!.view)
        }
        
        StudentManager.sharedInstance().requestStudentsInformations { (list, errorMessage) in
            LoadingView.hide()
            
            if errorMessage != nil {
                Dialogs.alert(controller: self, title: "Error", message: errorMessage!)
                return
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:HomeViewController.REFRESH_NOTIFICATION), object: nil)
        }
    }
    
    static func addRefreshListener(object : Any, selector : Selector) {
        NotificationCenter.default.addObserver(object, selector: selector, name: NSNotification.Name(rawValue: HomeViewController.REFRESH_NOTIFICATION), object: nil)
    }
    
    static func removeRefreshListener(object : Any) {
        NotificationCenter.default.removeObserver(object)
    }
    
    private func refreshCurrentStudentData() {
        updateLocationButton.isEnabled = false
        
        StudentManager.sharedInstance().requestCurrentStudentLocation { (info, errorMessage) in
            DispatchQueue.main.async {
                self.updateLocationButton.isEnabled = true
            }
        }
    }

}
