//
//  EnterLocationViewController.swift
//  On The Map
//
//  Created by SoSucesso on 02/09/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit
import MapKit

class EnterLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var labelQuestion: UILabel!
    @IBOutlet weak var textfield: LocationTextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    private var coordinate : CLLocationCoordinate2D?
    private let geoCoder = CLGeocoder()
    private var locationString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureToolbar()
        configureLabel()
        
        let buttonColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        confirmButton.backgroundColor = buttonColor
        confirmButton.layer.cornerRadius = 5
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = UIColor.black.cgColor
        let padding = CGFloat(16)
        confirmButton.contentEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        mapView.isHidden = true
        
        textfield.setPlaceHolder(text: "Type your location")
        textfield.delegate = self
    }
    
    private func configureToolbar() {
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
    }
    
    private func configureLabel() {
        let string = "Where are you\nstuding\ntoday?"
        let boldRange = NSRange(location: 14, length: 7)
        
        let fontSize = CGFloat(30)
        let fontColor = UIColor.blue
        let attrs = [
            NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
            NSForegroundColorAttributeName: fontColor
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        attrStr.setAttributes([
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: fontSize),
            NSForegroundColorAttributeName: fontColor
            ], range: boldRange)
        
        labelQuestion.attributedText = attrStr
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmAction() {
        if coordinate == nil {
            findOnTheMap()
        } else {
            submitLocation()
        }
    }
    
    private func findOnTheMap() {
        guard let address = textfield.text, !address.isEmpty else {
            Dialogs.alert(controller: self, title: "Ops", message: "Type your location")
            return
        }
        
        LoadingView.show(inView: view)
        setUIEnabled(false)
        
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            
            func showError() {
                Dialogs.alert(controller: self, title: "Error", message: "No location found for that address")
            }
            
            LoadingView.hide()
            DispatchQueue.main.async {
                self.setUIEnabled(true)
            }
            
            if error != nil {
                showError()
                return
            }
            
            guard let places = placemarks, places.count > 0, let location = places[0].location else {
                showError()
                return
            }
            
            self.coordinate = location.coordinate
            self.locationString = address
            
            DispatchQueue.main.async {
                self.showMap()
            }
            
        })
        
    }
    
    private func submitLocation() {
        guard let link = textfield.text, !link.isEmpty else {
            Dialogs.alert(controller: self, title: "Ops", message: "Type a link to share")
            return
        }
        
        var newLink = link
        if !link.hasPrefix("http://") || !link.hasPrefix("https://") {
            newLink = "http://"+link
        }
        
        guard let url = URL(string: newLink), UIApplication.shared.canOpenURL(url) else {
            Dialogs.alert(controller: self, title: "Ops", message: "This link seems to be invalid")
            return
        }
        
        var newInfo = StudentInformation()
        newInfo.latitude = coordinate!.latitude
        newInfo.longitude = coordinate!.longitude
        newInfo.mapString = locationString
        newInfo.mediaURL = newLink

        LoadingView.show(inView: view)
        setUIEnabled(false)
        
        StudentManager.sharedInstance().requestUpdateLocation(newInfo: newInfo) { (updatedInfo, error) in
            LoadingView.hide()
            DispatchQueue.main.async {
                self.setUIEnabled(true)
            }
            
            if error != nil {
                Dialogs.alert(controller: self, title: "Error", message: error!)
                return
            }
            
            DispatchQueue.main.async {
                self.cancel()
            }
        }

    }
    
    private func setUIEnabled(_ enabled : Bool) {
        confirmButton.isEnabled = enabled
        textfield.isEnabled = enabled
    }
    
    private func showMap() {
        let pin = MKPointAnnotation()
        pin.coordinate = self.coordinate!
        mapView.addAnnotation(pin)
        mapView.isHidden = false
        mapView.showAnnotations(self.mapView.annotations, animated: true)
        
        textfield.text = ""
        textfield.setPlaceHolder(text: "Enter a link to share here")
        textfield.keyboardType = .URL
        textfield.returnKeyType = .send
        
        confirmButton.setTitle("Submit", for: .normal)
        cancelButton.tintColor = UIColor.white
        upperView.removeFromSuperview()
    }
    
    
}

extension EnterLocationViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        confirmAction()
        return false
    }
    
}
