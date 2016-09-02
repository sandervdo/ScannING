//
//  QRCodeViewController.swift
//  ScannING
//
//  Created by Victor Li on 22-03-16.
//  Copyright © 2016 ScannING. All rights reserved.
//

import UIKit
import AVFoundation
import MBProgressHUD

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var qrCodeView: UIView!
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    var captureSession : AVCaptureSession?
    var videoPreviewLayer : AVCaptureVideoPreviewLayer?
    var qrCodeFrameView : UIView?
    var hud : MBProgressHUD?
    
    var transaction : [String:AnyObject]?
    
    override func viewDidLoad() {
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
//        navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "Lato-Light", size: 20)!]
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 119.0 / 255.0, green: 114.0 / 255.0, blue: 108.0 / 255.0, alpha: 1.0)]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as! [String : AnyObject] // 119, 114, 108
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input as AVCaptureInput)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = qrCodeView.layer.bounds
            qrCodeView.layer.addSublayer(videoPreviewLayer!)
            
            captureSession?.startRunning()
            
            qrCodeFrameView = UIView()
            qrCodeFrameView?.layer.borderColor = UIColor.redColor().CGColor
            qrCodeFrameView?.layer.borderWidth = 2
            qrCodeView.addSubview(qrCodeFrameView!)
            qrCodeView.bringSubviewToFront(qrCodeFrameView!)
            
            NSNotificationCenter.defaultCenter().addObserver(
                self,
                selector: "callbackWithTransaction:",
                name: "replyTransaction",
                object: nil)
        } catch {
            print(error)
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            print("No QR code is detected")
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil && metadataObj.stringValue.substringToIndex(metadataObj.stringValue.startIndex.advancedBy(8)) == "ScannING" {
                qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
                print(metadataObj.stringValue)
                captureSession?.stopRunning()
                
                hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
                hud!.show(true)
                processToken(metadataObj.stringValue)
            }
            
            if metadataObj.stringValue != nil {
                print(metadataObj.stringValue)
            }
        }
    }
    
    func processToken(token: String) {
        print("Token: \(token)")
        APIConnector.sharedInstance.postToken(token, iban: "NL84INGB5979320650")
    }
    
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toConfirmationSegue" {
            let vc = segue.destinationViewController as! ConfirmationViewController
            vc.transaction = transaction
        }
    }
    
    @objc func callbackWithTransaction(notification: NSNotification){
        if let transactionDict = notification.object as? [String:AnyObject] {
            hud!.hide(true)
            print("Transaction: \(transaction)")
            transaction = transactionDict
            
            qrImageView.hidden = true
            transactionView.hidden = false
            qrCodeView?.hidden = true
            //avatarImageView.image = UIImage(named: "Mcdonalds_Logo")
            
            if let requester = transactionDict["requester"] {
                if let name = requester["name"] as? String {
                    nameLabel.text = name
                }
                if let avatarURL = requester["avatar"] {
                    if let data = NSData(contentsOfURL: NSURL(string: avatarURL as! String)!) {
                        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
                        avatarImageView.image = UIImage(data: data)
                    }
                }
            }
            
            if let amount = transactionDict["amount"] as? String {
                let amountDouble = Double(amount)
                amountLabel.text = String(format: "€%.2f", amountDouble!)
            }
        }
    }
    
    @IBAction func acceptPressed(sender: UIButton) {
        if let token = transaction!["token"] as? String {
             APIConnector.sharedInstance.putConfirm(token, confirm: true)
        }
        
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        let image = UIImage(named: "Checkmark")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        hud!.mode = MBProgressHUDMode.CustomView
        hud!.customView = UIImageView(image: image)
        hud!.square = true
        hud!.labelText = "Payment success"
        dispatch_async(dispatch_get_main_queue()) {
            self.hud!.hide(true, afterDelay: 3)
        }
        hud!.show(true)
        
        qrImageView.hidden = false
        transactionView.hidden = true
        qrCodeView?.hidden = false
        captureSession?.startRunning()
    }
    
    @IBAction func declinePressed(sender: UIButton) {
        if let token = transaction!["token"] as? String {
            APIConnector.sharedInstance.putConfirm(token, confirm: false)
        }
        
        hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        let image = UIImage(named: "Cross")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        hud!.mode = MBProgressHUDMode.CustomView
        hud!.customView = UIImageView(image: image)
        hud!.square = true
        hud!.labelText = "Payment failed"
        dispatch_async(dispatch_get_main_queue()) {
            self.hud!.hide(true, afterDelay: 3)
        }
        hud!.show(true)
        
        qrImageView.hidden = false
        transactionView.hidden = true
        qrCodeView?.hidden = false
        captureSession?.startRunning()
    }
}
