//
//  extension.swift
//  OnTheMap
//
//  Created by Maram Saleh on 04/05/1441 AH.
//  Copyright © 1441 Maram Saleh. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func createAlert (title: String, message: String){
        DispatchQueue.main.async {

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            return }))
        self.present(alert, animated: true, completion: nil)
        }
    }

    
    func stsrtAnActivityIndicator ()-> UIActivityIndicatorView{
        let ai = UIActivityIndicatorView(style: .white)
        self.view.addSubview(ai)
        self.view.bringSubviewToFront(ai)
        ai.center = self.view.center
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }
    
    
}
