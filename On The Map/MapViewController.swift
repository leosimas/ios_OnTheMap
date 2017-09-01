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
        mapView.removeAnnotations( mapView.annotations )
        
        let array = StudentManager.sharedInstance().infoArray
        
        for info in array {
            let pin = StudentPin(info : info)
            mapView.addAnnotation(pin)
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
        
        func showError() {
            Alert.alert(controller: self, title: "Sorry :(", message: "Couldn't open this URL : \(studentPin.studentInformation.mediaURL)")
        }
        
        guard let url = URL(string: studentPin.studentInformation.mediaURL) else {
            showError()
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            showError()
        }
    }
    
}
