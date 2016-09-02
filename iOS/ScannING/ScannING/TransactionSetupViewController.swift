//
//  TransactionSetupViewController.swift
//  ScannING
//
//  Created by Victor Li on 22-03-16.
//  Copyright © 2016 ScannING. All rights reserved.
//

import UIKit
import MBProgressHUD

class TransactionSetupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var amount : Int = 0
    var token : String = ""
    var hud : MBProgressHUD?
    var menuOpen = false;
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        if self.revealViewController() != nil {
            menuButton.target = self
            menuButton.action = "menuPressed"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        amountTextField.becomeFirstResponder()
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "callbackWithToken:",
            name: "replyToken",
            object: nil)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 119.0 / 255.0, green: 114.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0)]//, //NSFontAttributeName: UIFont(name: "Lato-Light", size: 22)!]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject] //UIFont(name: "Lato-Light", size: 22)
    }
    
    @IBAction func nextPressed(sender: AnyObject) {
        if amountTextField.text == "" {
            let alert = UIAlertView()
            alert.title = "No amount"
            alert.message = "Please fill in an amount"
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        amount = Int(amountTextField.text!)!
        if amount == 0 {
            let alert = UIAlertView()
            alert.title = "Invalid amount"
            alert.message = "Please fill in an amount"
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        // Call request
        
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud!.show(true)
        
        APIConnector.sharedInstance.postNewTransaction("description", amount: Double(amount) / 100.0, iban: "NL83INGB3151523529")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toQRSegue" {
            let vc = segue.destinationViewController as! QRCodeDisplay
            vc.amount = amount
            vc.token = token
        }
    }
    
    func menuPressed() {
        self.revealViewController().performSelectorOnMainThread("revealToggle:", withObject: nil, waitUntilDone: false)
        menuOpen = !menuOpen
        if menuOpen {
            amountTextField.resignFirstResponder()
        } else {
            amountTextField.becomeFirstResponder()
        }
    }
    
    @objc func callbackWithToken(notification: NSNotification){
        if let notificationToken = notification.object {
            token = notificationToken as! String
            hud!.hide(true)
            self.performSegueWithIdentifier("toQRSegue", sender: self)
        }
    }
    
}
