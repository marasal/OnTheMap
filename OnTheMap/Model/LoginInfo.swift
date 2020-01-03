//
//  LoginInfo.swift
//  OnTheMap
//
//  Created by Maram Saleh on 13/04/1441 AH.
//  Copyright © 1441 Maram Saleh. All rights reserved.
//

import Foundation

//Request

struct loginRequest: Codable {
    let email: String
    let password: String
}



//Response


struct loginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool?
    let key: String?
}

struct Session: Codable {
    let id: String?
    let expiration: String?
}

