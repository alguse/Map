//
//  StartingView.swift
//  Map
//
//  Created by Rodolfo Castillo on 05/03/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import Foundation
import UIKit

class StartingView: UIViewController {
    
    var data = NSUserDefaults.standardUserDefaults()
    var Name: String!
    let loginView = LoginView()
    
    override func viewDidLoad() {
        if FBSDKAccessToken.currentAccessToken() != nil {
            if data.stringForKey("Name") == nil {
                
                self.presentViewController(loginView, animated: true, completion: nil)
            } else {
                self.Name = data.stringForKey("Name")
            }
            print(Name)
        } else {
            self.presentViewController(loginView, animated: true, completion: nil)
        }
    }
}