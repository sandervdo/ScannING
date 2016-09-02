//
//  ConfirmationViewController.swift
//  ScannING
//
//  Created by Victor Li on 22-03-16.
//  Copyright © 2016 ScannING. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var transaction : [String:AnyObject]!
    
    override func viewDidLoad() {
        if let priceString = transaction["price"] as? String {
            let price = Int(priceString)
            let amount : Double = Double(price!) / 100
            amountLabel.text = String(format: "€%.2f", amount)
        }
        
        if let name = transaction["name"] as? String {
            nameLabel.text = name
        }
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        avatarImageView.image = UIImage(named: "Mcdonalds_Logo")
    }
}
