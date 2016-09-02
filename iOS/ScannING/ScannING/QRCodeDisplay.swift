//
//  QRCodeDisplay.swift
//  ScannING
//
//  Created by Victor Li on 22-03-16.
//  Copyright © 2016 ScannING. All rights reserved.
//

import UIKit
import MBProgressHUD

class QRCodeDisplay: UIViewController {
    @IBOutlet weak var qrCodeImageView: UIImageView!
    //@IBOutlet weak var qrCodeBackground: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var amount : Int?
    var token : String!
    var qrcodeImage : CIImage!
    var textfield : UITextField!
    
    var timer : NSTimer?
    var hud : MBProgressHUD?
    
    var state = 1
    
    override func viewDidLoad() {
        let data = token.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("Q", forKey: "inputCorrectionLevel")
        
        qrcodeImage = filter?.outputImage
        
        let scaleX = qrCodeImageView.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = qrCodeImageView.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        
        qrCodeImageView.image = UIImage(CIImage: transformedImage)
        
        //qrCodeBackground.layer.cornerRadius = 8
        
        //avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        //avatarImageView.image = UIImage(named: "Mcdonalds_Logo")
        
        if let amountVar = amount {
            print(amountVar)
            let amountDouble : Double = Double(amountVar) / 100.0
            print(amountDouble)
            priceLable.text = String(format: "€%.2f", amountDouble)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "callbackWithPollStatus:",
            name: "replyPoll",
            object: nil)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target:self, selector: Selector("pollRequest"), userInfo: nil, repeats: true)
    }

    func pollRequest() {
        print("poll")
        APIConnector.sharedInstance.pollTransaction(token)
    }
    
    func callbackWithPollStatus(notification: NSNotification) {
        print("callback")
        if let JSON = notification.object as? [String:AnyObject] {
            if state == 1 {
                print("-----> STATE 1")
                if let client = JSON["client"] as? [String:AnyObject] {
                    state = 2
                    if let avatarURL = client["avatar"] {
                        if let data = NSData(contentsOfURL: NSURL(string: avatarURL as! String)!) {
                            qrCodeImageView.layer.cornerRadius = qrCodeImageView.frame.width / 2
                            qrCodeImageView.image = UIImage(data: data)
                        }
                    }
                    
                    if let name = client["name"] as? String {
                        nameLabel.text = name
                    }
                    
                    messageLabel.hidden = false;
                }
                return;
            }
            
            if state == 2 {
                print("-----> STATE 2")
                print(JSON["confirmed"])
                    if let confirmed = Int(JSON["confirmed"] as! String) {
                        print("-------> is int")
                        if confirmed == 1 {
                            print("-----> TRUE")
                            hud = MBProgressHUD.showHUDAddedTo(self.navigationController?.parentViewController?.view, animated: true)
                            let image = UIImage(named: "Checkmark")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                            hud!.mode = MBProgressHUDMode.CustomView
                            hud!.customView = UIImageView(image: image)
                            hud!.square = true
                            hud!.labelText = "Payment success"
                            hud!.show(true)
                            dispatch_async(dispatch_get_main_queue()) {
                                self.hud!.hide(true, afterDelay: 3)
                            }
                            
                            if (timer != nil) {
                                timer!.invalidate()
                                timer = nil
                            }
                        } else if confirmed == 0 {
                            print("-----> FALSE")
                            hud = MBProgressHUD.showHUDAddedTo(self.navigationController?.parentViewController?.view, animated: true)
                            let image = UIImage(named: "Cross")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                            hud!.mode = MBProgressHUDMode.CustomView
                            hud!.customView = UIImageView(image: image)
                            hud!.square = true
                            hud!.labelText = "Payment failed"
                            dispatch_async(dispatch_get_main_queue()) {
                                self.hud!.hide(true, afterDelay: 3)
                            }
                            hud!.show(true)
                            
                            if (timer != nil) {
                                timer!.invalidate()
                                timer = nil
                            }
                            
    //                        let filter = CIFilter(name: "CIQRCodeGenerator")
    //                        
    //                        qrcodeImage = filter?.outputImage
    //                        
    //                        let scaleX = qrCodeImageView.frame.size.width / qrcodeImage.extent.size.width
    //                        let scaleY = qrCodeImageView.frame.size.height / qrcodeImage.extent.size.height
    //                        
    //                        let transformedImage = qrcodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
    //                        
    //                        qrCodeImageView.image = UIImage(CIImage: transformedImage)
    //                        
    //                        nameLabel.
                        }
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                }
        }
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
