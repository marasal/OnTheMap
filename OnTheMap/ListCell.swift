//
//  ListCell.swift
//  OnTheMap
//
//  Created by Maram Saleh on 03/05/1441 AH.
//  Copyright © 1441 Maram Saleh. All rights reserved.
//
import Foundation
import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var locationIconImage: UIImageView!
    @IBOutlet weak var studentInfoLabel: UILabel!
    @IBOutlet weak var mediaLinkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
