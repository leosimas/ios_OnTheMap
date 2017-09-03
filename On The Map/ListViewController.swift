//
//  ListViewController.swift
//  On The Map
//
//  Created by SoSucesso on 02/09/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class ListViewController : BaseStudentInformationViewController {
    
    @IBOutlet weak var tableView : UITableView!
    
    override func onRefreshed() {
        tableView.reloadData()
    }
    
}

extension ListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentData.sharedInstance().infoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentInfo = StudentData.sharedInstance().infoArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        cell.imageView?.image = #imageLiteral(resourceName: "icon_pin")
        cell.textLabel?.text = studentInfo.fullName()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInfo = StudentData.sharedInstance().infoArray[indexPath.row]
        openUrl(studentInformation: studentInfo)
    }
    
}
