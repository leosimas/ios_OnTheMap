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
    
    @IBOutlet var mapView: MKMapView!
    
    override func onRefreshed() {
        DispatchQueue.main.async {
            self.mapView.removeAnnotations( self.mapView.annotations )
            
            let array = StudentManager.sharedInstance().infoArray
            
            for info in array {
                let pin = StudentPin(info : info)
                self.mapView.addAnnotation(pin)
            }
            
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pinview"
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if (view == nil) {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            view!.canShowCallout = true
            view!.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            view!.annotation = annotation
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let studentPin = view.annotation as! StudentPin
        openUrl(studentInformation: studentPin.studentInformation)
    }
    
}
