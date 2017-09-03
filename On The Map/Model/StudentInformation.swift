//
//  StudentInformation.swift
//  On The Map
//
//  Created by SoSucesso on 28/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

struct StudentInformation {
    
    var objectId : String
    var uniqueKey : String
    var firstName : String
    var lastName : String
    var mapString : String
    var mediaURL : String
    var latitude : Double
    var longitude : Double
    
    init(json : [String:AnyObject?]) {
        // found an item with nil:
        if let key = json["uniqueKey"] as? String {
            uniqueKey = key
        } else {
            uniqueKey = ""
        }
        
        objectId = json["objectId"] as! String
        firstName = json["firstName"] as! String
        lastName = json["lastName"] as! String
        mapString = json["mapString"] as! String
        mediaURL = json["mediaURL"] as! String
        latitude = json["latitude"] as! Double
        longitude = json["longitude"] as! Double
    }
    
    init() {
        objectId = ""
        uniqueKey = ""
        firstName = ""
        lastName = ""
        mapString = ""
        mediaURL = ""
        latitude = 0
        longitude = 0
    }
    
    func fullName() -> String {
        return firstName + " " + lastName
    }
    
}
