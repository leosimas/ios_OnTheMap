//
//  User.swift
//  On The Map
//
//  Created by SoSucesso on 02/09/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

struct User {
    
    var firstName : String
    var lastName : String
    
    init(json : [String:AnyObject?]) {
        firstName = json["first_name"] as! String
        lastName = json["last_name"] as! String
    }
    
}
