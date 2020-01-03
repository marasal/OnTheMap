//
//  MapVC.swift
//  OnTheMap
//
//  Created by Maram Saleh on 01/05/1441 AH.
//  Copyright © 1441 Maram Saleh. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapVC: ContainerVC, MKMapViewDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
              super.viewDidLoad()
              mapView.delegate = self
          }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Global.studentLocations == nil {
            DispatchQueue.main.async {
            super.loadLocations(self)
            self.loadStudentLocation()
            }
        } else {
            self.loadStudentLocation()
        }
    }
    
    
    @IBAction func addPinTapped(_ sender: Any) {
        addPin (segueName : "MapToAddNewLocation")
    }
    
    @IBAction func reloadLocations(_ sender: Any) {
        DispatchQueue.main.async {
            super.loadLocations(self)
            self.loadStudentLocation()
        }
    }
    
    
  
    
    
    func loadStudentLocation (){
        var map = [MKPointAnnotation]()
        if let studentLocations = Global.studentLocations {
            for location in studentLocations {
                    let lat = CLLocationDegrees(location.latitude ?? 0.0)
                    let long = CLLocationDegrees(location.longitude ?? 0.0)
                    let cords = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let mediaURL = location.mediaURL ?? " "
                    let firstName = location.firstName ?? " "
                    let lastName = location.lastName ?? " "
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = cords
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = mediaURL
                if !mapView.annotations.contains(where: {$0.title == annotation.title}){
                    map.append(annotation)
                }
                }
                self.mapView.addAnnotations(map)
            }
        }
        
    
    
    @IBAction func logout(_ sender: Any) {
        API.deleteSession {(error) in
            if let error = error {
                super.createAlert(title: "Error", message: error.localizedDescription)
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
   
    

    
    //Map Delegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle ?? nil, let url = URL(string: toOpen) , app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}

