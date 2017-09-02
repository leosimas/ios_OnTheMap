//
//  StudentInformation.swift
//  On The Map
//
//  Created by SoSucesso on 28/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

struct StudentInformation {
    
//    {
//    "objectId": "SHqKoU9IZs",
//    "uniqueKey": "u156125",
//    "firstName": "Spiros",
//    "lastName": "Raptis",
//    "mapString": "Ikaria,greece",
//    "mediaURL": "http://www.facebook.com",
//    "latitude": 40.507279,
//    "longitude": 22.2822461,
//    "createdAt": "2017-08-28T22:34:00.575Z",
//    "updatedAt": "2017-08-28T22:34:00.575Z"
//    }
    
    var objectId : String
    var uniqueKey : String
    var firstName : String
    var lastName : String
    var mapString : String
    var mediaURL : String
    var latitude : Double
    var longitude : Double
    
    init(json : [String:AnyObject?]) {
        objectId = json["objectId"] as! String
        uniqueKey = json["uniqueKey"] as! String
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
