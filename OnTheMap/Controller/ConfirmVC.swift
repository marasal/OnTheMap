//
//  ConfirmVC.swift
//  OnTheMap
//
//  Created by Maram Saleh on 04/05/1441 AH.
//  Copyright © 1441 Maram Saleh. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ConfirmVC: UIViewController {

    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var coordinate : CLLocationCoordinate2D!
    var  locationName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextField.delegate = self
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        //zooming to location
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
        mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
                      }
        
    }
    
    @IBAction func SubmitButton(_ sender: Any) {
        if linkTextField.text != ""   {
            let ai = self.stsrtAnActivityIndicator()

            API.postStudentLocation(link: linkTextField.text!, locationCoordinate: coordinate, locationName: locationName) { (error) in
                DispatchQueue.main.async {
                    ai.startAnimating()
                }
                if let error = error {
                    self.createAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                UserDefaults.standard.set(true, forKey: "AllocateLocation")
                DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            createAlert(title: "Enter the Link", message: "Link field should not be empty")

        }
       
    }
    
}

extension ConfirmVC : UITextFieldDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
