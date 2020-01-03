//
//  APIs.swift
//  OnTheMap
//
//  Created by Maram on 13/04/1441 AH.
//  Copyright © 1441 Maram. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class dataKeeper{
    var loginKey: String = ""
    var randomFirstName : String = ""
    var randomLastName : String = ""
    var StudentLocation : String = ""
    
    
    static let shared = dataKeeper()
    
}

class API: NSObject {
    
    
    static func postSession(_ email: String,_ password: String, completion: @escaping (Bool, Error?)->()) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if error != nil {
                completion (false, error)
                return }
            guard let data = data else { return }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                let statusNo = (response as? HTTPURLResponse)?.statusCode
                print("the status code is \(String(describing: statusNo))")
                completion (false, error)
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            let decoder = JSONDecoder()
            
            do {
                let dataDecoded = try decoder.decode(loginResponse.self, from: newData)

                dataKeeper.shared.loginKey = dataDecoded.account.key ?? ""
                              getRandomUserData { (success, errorMessage) in
                    if success {
                        print(dataKeeper.shared.randomFirstName)
                    } else {
                        print(errorMessage ?? "Unknown error")
                    }
                }
                completion (true, nil)
            } catch let error {
                print("could not decode data \(error.localizedDescription)")
                completion (false, nil)
                return
            }
        }
        task.resume()
}
    
    
    
    static func deleteSession (completion: @escaping (Error?)-> ()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion (error)
                return }

            let range = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            print ( String(data: newData!, encoding: .utf8)!)
            completion(nil)
    }
         task.resume()
}

    
    
    static func getRandomUserData(completion: @escaping (_ success: Bool, _ errorString: String?) -> Void){
        if dataKeeper.shared.loginKey == "" {
            completion(false, "There is no login Key")
            return
        }
        
        let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/\(dataKeeper.shared.loginKey)")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                
                completion (false, error?.localizedDescription)
                    return }
                guard let data = data else { return }
                guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                    let statusNo = (response as? HTTPURLResponse)?.statusCode
                    print("the status code is \(String(describing: statusNo))")
                    completion (false, error?.localizedDescription)

                    return
                }
            let range =  5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            guard let dictionary = try? JSONSerialization.jsonObject(with: newData, options: []) as? [String: Any] else{
                completion(false, error?.localizedDescription ) //"Something went wrong"
                return
            }
            
            let firstName : String?
            let lastName: String?
            
            if let user = dictionary["user"] as? [String: Any]{
                firstName = user["first_name"] as? String
                lastName = user ["last_name"] as? String

            } else {
                firstName = dictionary["first_name"] as? String
                lastName = dictionary ["last_name"] as? String
            }
            dataKeeper.shared.randomFirstName = firstName ?? ""
            dataKeeper.shared.randomLastName = lastName ?? ""
            print(dataKeeper.shared.randomFirstName, dataKeeper.shared.randomLastName,"^^^^^^^^^^^^^^^^^^^^^^^^^")
            completion(true, nil)
        }
        
        task.resume()
    }
        
    
    
    
    
    //Parse API
    
    static func getStudentLocation(completion: @escaping ([StudentLocation]?, Error?)->()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt/StudentLocation?limit=100")!)
    
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error
                completion(nil, error)
                return
            }
            guard let data = data else { return }
            guard let status = (response as? HTTPURLResponse)?.statusCode, status >= 200 && status <= 399 else {
                let statusNo = (response as? HTTPURLResponse)?.statusCode
                print("the status code is \(String(describing: statusNo))")
                completion (nil, error)
                return
            }

      
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(Result.self, from: data)
                completion(result.results, nil)
            } catch {
                print("Something went wrong with decoding data\n \(error.localizedDescription)")
            }
        }
        task.resume()
        
        

    }
    
    
    static func postStudentLocation(link: String, locationCoordinate: CLLocationCoordinate2D, locationName: String, completion: @escaping (Error?) -> Void) {
           
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(dataKeeper.shared.loginKey)\", \"firstName\": \"\(dataKeeper.shared.randomFirstName)\", \"lastName\": \"\(dataKeeper.shared.randomLastName)\",\"mapString\": \"\(locationName)\", \"mediaURL\": \"\(link)\",\"latitude\": \(locationCoordinate.latitude), \"longitude\": \(locationCoordinate.longitude)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(error)
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            completion(nil)
        }
        task.resume()
    }
    
    
    

}

