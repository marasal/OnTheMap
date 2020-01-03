//
//  ContainerVC.swift
//  OnTheMap
//
//  Created by Maram Saleh on 03/05/1441 AH.
//  Copyright © 1441 Maram Saleh. All rights reserved.
//

import Foundation
import UIKit

class ContainerVC: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func addPin (segueName : String){
        if UserDefaults.standard.value(forKey: "AllocateLocation") != nil {
            let alert = UIAlertController(title: "You already posted a student location." , message: "Would you like to overwrite your current location?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
                return }))
            alert.addAction(UIAlertAction(title: "Overwrite", style: UIAlertAction.Style.destructive, handler: { _ in
                self.performSegue(withIdentifier: segueName, sender: self)
                           return }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            
            self.performSegue(withIdentifier: segueName, sender: self)

        }
    }
    
    
    func loadLocations(_ sender: Any){
        let ai = self.stsrtAnActivityIndicator()
        API.getStudentLocation { (result, error) in
            DispatchQueue.main.async {
            ai.startAnimating()
            }
            guard let result = result else {
                self.createAlert(title: "Error", message: "Failed to download the locations")
                return
            }
            guard result.count != 0 else{
                self.createAlert(title: "Error", message: "There is no result")
                return
            }
            Global.studentLocations = result
        }
    }
    
    
 
}

