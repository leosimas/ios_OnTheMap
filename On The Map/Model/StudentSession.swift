//
//  StudentSession.swift
//  On The Map
//
//  Created by SoSucesso on 02/09/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import Foundation

struct StudentSession {
    
    var key : String
    
    init(json : [String:AnyObject?]) {
        let account = json["account"] as! [String:AnyObject?]
        key = account["key"] as! String
    }
}
