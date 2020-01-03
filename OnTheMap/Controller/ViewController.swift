//
//  ViewController.swift
//  OnTheMap
//
//  Created by Maram Saleh on 12/04/1441 AH.
//  Copyright © 1441 Maram Saleh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    
    @IBAction func loginTapped(_ sender: Any) {
            if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!  {
            createAlert(title: "Warning", message: "Email and password should not be empty")
        }
        
        let ai = self.stsrtAnActivityIndicator()
        
        API.postSession(emailTextField.text!, passwordTextField.text!) { (successful, error) in
            DispatchQueue.main.async {
                ai.startAnimating()
                
                if let error = error {
                    self.createAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                if !successful {
                    self.createAlert(title: "Invalid", message: "Invalid email or password")
                } else {
                    DispatchQueue.main.async {
                        self.emailTextField.text = ""
                        self.passwordTextField.text = ""
                        self.performSegue(withIdentifier: "showTapVC", sender: self)
                    }
                }
            }
        }
    }
    
    
    
    
}

