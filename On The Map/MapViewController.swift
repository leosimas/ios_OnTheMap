//
//  MapViewController.swift
//  On The Map
//
//  Created by SoSucesso on 29/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : BaseStudentInformationViewController {
    //MKMapViewDelegate
    
    @IBOutlet var mapView: MKMapView!
    
    var pinsList : [MKPointAnnotation] = []
    
    override func onRefreshed() {
        let array = StudentManager.sharedInstance().infoArray
        
        mapView.removeAnnotations(pinsList)
        pinsList.removeAll()
        
        for info in array {
            let pin = MKPointAnnotation()
            pin.coordinate = CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
            pin.title = info.fullName()
            pin.subtitle = info.mediaURL
            
            
            pinsList.append(pin)
        }
        
        mapView.addAnnotations(pinsList)
    }
    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        view.annotation.in
//    }
    
}
