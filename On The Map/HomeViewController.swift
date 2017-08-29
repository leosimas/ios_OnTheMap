//
//  HomeViewController.swift
//  On The Map
//
//  Created by SoSucesso on 27/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshStudentsData()
    }
    
    @IBAction func logoutPressed() {
        Alert.confirm(controller: self, title: "Logout", message: "Are you sure?") { (confirmed) in
            if !confirmed {
                return
            }
            
            UdacityClient.sharedInstance().requestLogout { (sucess, error) in
                if !sucess {
                    Alert.alert(controller: self, title: "Error", message: error!.localizedDescription)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refresh() {
        refreshStudentsData()
    }
    
    private func refreshStudentsData() {
        StudentManager.sharedInstance().requestStudentsInformations { (list, errorMessage) in
            if errorMessage != nil {
                Alert.alert(controller: self, title: "Error", message: errorMessage!)
                return
            }
            
            print(list)
        }
    }

}
