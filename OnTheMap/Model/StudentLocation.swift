//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Maram Saleh on 01/05/1441 AH.
//  Copyright © 1441 Maram Saleh. All rights reserved.
//

import Foundation

struct Result: Codable {
    let results: [StudentLocation]?
}

struct StudentLocation: Codable {
    var createdAt : String?
    var firstName : String?
    var lastName : String?
    var latitude : Double?
    var longitude : Double?
    var mapString : String?
    var mediaURL : String?
    var objectId : String?
    var uniqueKey : String?
    var updatedAt : String?
}


