//
//  WelcomeViewController.swift
//  ScannING
//
//  Created by Victor Li on 23-03-16.
//  Copyright © 2016 ScannING. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
}
