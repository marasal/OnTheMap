//
//  ListVC.swift
//  OnTheMap
//
//  Created by Maram Saleh on 03/05/1441 AH.
//  Copyright © 1441 Maram Saleh. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class ListVC: ContainerVC {

    @IBOutlet weak var tableView: UITableView!
    
    var studentData = [StudentLocation]()

    
    override func viewDidLoad() {
                super.viewDidLoad()
                tableView.delegate = self
                tableView.dataSource = self

          }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       if Global.studentLocations == nil {
        DispatchQueue.main.async {
            super.loadLocations(self)
            }
        
       } else {
        self.studentData = Global.studentLocations!
        }
    }
    
    
    @IBAction func addPinTapped(_ sender: Any) {
        addPin (segueName : "TableToAddNewLocation")

    }
    
    
    @IBAction func reloadLocations(_ sender: Any) {
        DispatchQueue.main.async {
            super.loadLocations(self) //here
               }
    }
}
    
    
extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier") as! ListCell
        let cellContent = studentData[(indexPath).row]
        cell.studentInfoLabel.text = "\(cellContent.firstName ?? " ")  \(cellContent.lastName ?? " ")"
        cell.mediaLinkLabel.text = cellContent.mediaURL
        cell.locationIconImage.image = UIImage(named: "icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let app = UIApplication.shared
        let link = studentData[(indexPath).row].mediaURL
        if let url = URL(string: link ?? "" ) , app.canOpenURL(url) {
             app.open(url, options: [:], completionHandler: nil)
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let link = self.studentData[(indexPath).row].mediaURL
            let app = UIApplication.shared
            if let toOpen = link ?? nil, let url = URL(string: toOpen) , app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
        
    
}



