//
//  StudentPin.swift
//  On The Map
//
//  Created by SoSucesso on 31/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import MapKit

class StudentPin : MKPointAnnotation {
    
    var studentInformation : StudentInformation
    
    init(info : StudentInformation) {
        studentInformation = info
        super.init()
        title = info.fullName()
        subtitle = info.mediaURL
        coordinate = CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
    }
    
}
