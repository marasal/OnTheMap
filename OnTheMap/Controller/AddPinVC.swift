//
//  AddPinVC.swift
//  OnTheMap
//
//  Created by Maram Saleh on 04/05/1441 AH.
//  Copyright © 1441 Maram Saleh. All rights reserved.
//

import UIKit
import CoreLocation

class AddPinVC: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    
    var locationCoordinate: CLLocationCoordinate2D!
    var locationName: String!
    
    
    @IBAction func CancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        guard let locationName = locationField.text?.trimmingCharacters(in: .whitespaces), !locationName.isEmpty else {
            createAlert(title: "Warning", message: "Location field should not be empty!")
            return
        }
        let ai = self.stsrtAnActivityIndicator()
               
        getCoordinates(locationName) { (Coordinate, error) in
            DispatchQueue.main.async {
                ai.startAnimating()
            }
            if let error = error {
                self.createAlert(title: "Not Found", message: "Try with different name")
                print(error.localizedDescription)
                return
            }
            self.locationCoordinate = Coordinate
            self.locationName = locationName
            self.performSegue(withIdentifier: "ToConfirmVCSegue", sender: self)
        }
    }
    
    
    func getCoordinates(_ Location: String, completionHandler: @escaping ( _ coordinate: CLLocationCoordinate2D?, _ error : Error?)->()){
           
           CLGeocoder().geocodeAddressString(     Location) { (placeMarks, error) in
            completionHandler (placeMarks?.first?.location?.coordinate, error)
               }
        
    }
        
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToConfirmVCSegue" {
            let vc = segue.destination as! ConfirmVC
            vc.locationName = locationName
            vc.coordinate = locationCoordinate
        }
    }
     
 

}
