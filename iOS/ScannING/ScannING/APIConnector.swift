//
//  APIConnector.swift
//  ScannING
//
//  Created by Victor Li on 22-03-16.
//  Copyright © 2016 ScannING. All rights reserved.
//

import Foundation
import Alamofire

class APIConnector {
    static let sharedInstance = APIConnector()

    func postNewTransaction(description: String, amount: Double, iban: String) {
        Alamofire.request(.POST, "http://213.187.246.84/api/payment-request", parameters:
            ["description" : description, "amount" : amount, "iban" : iban])
            .responseJSON(completionHandler: { response in
                print(response)
                print(response.result.value!)
                if let JSON = response.result.value {
                    print("\(JSON)")
                    
                    let notification = NSNotification(name: "replyToken", object: "\(JSON["token"] as! String)")
                    NSNotificationCenter.defaultCenter().postNotification(notification)
                }
            })
    }
    
    func postToken(token: String, iban: String) {
        Alamofire.request(.POST, "http://213.187.246.84/api/payment-request/payment", parameters:
            ["iban" : iban, "token" : token])
            .responseJSON(completionHandler: { response in
                print(response)
                print(response.result.value!)
                if let JSON = response.result.value {
                    print("\(JSON)")
                    let notification = NSNotification(name: "replyTransaction", object: JSON)
                    NSNotificationCenter.defaultCenter().postNotification(notification)
                }
            })
    }
    
    func pollTransaction(token: String) {
        Alamofire.request(.GET, "http://213.187.246.84/api/payment-request/\(token)", parameters: nil)
            .responseJSON(completionHandler: { response in
                print(response)
                print(response.result.value!)
                if let JSON = response.result.value {
                    print("\(JSON)")
                    let notification = NSNotification(name: "replyPoll", object: JSON)
                    NSNotificationCenter.defaultCenter().postNotification(notification)
                }
            })
    }
    
    func putConfirm(token: String, confirm: Bool) {
        Alamofire.request(.POST, "http://213.187.246.84/api/payment-request/confirm", parameters:
            ["confirm" : confirm, "token" : token])
            .responseJSON(completionHandler: { response in
                print(response)
                print(response.result.value!)
                if let JSON = response.result.value {
                    print("\(JSON)")
                    //let notification = NSNotification(name: "replyToken", object: "ScannINGWybIvkPLenZI1LVZJLXeHRueewI7T1u1cQ2USLNbqmKe3gMlkRuViyw3276C5IfnBWE96egFj5")
                    //NSNotificationCenter.defaultCenter().postNotification(notification)
                }
            })
    }
}