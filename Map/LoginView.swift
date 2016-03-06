//
//  LoginView.swift
//  Map
//
//  Created by Rodolfo Castillo on 05/03/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import Foundation
import UIKit



class LoginView: UIViewController, FBSDKLoginButtonDelegate {
    
    
    var BetterLoginButton: UIButton!
    var data: NSUserDefaults!
    
    override func viewDidLoad() {
        data = NSUserDefaults.standardUserDefaults()
        setUPButton()
        
        
    }
    
    func setUPButton(){
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        self.view.addSubview(loginView)
        loginView.center = self.view.center
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
    }
    
    func fetchData(){
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,gender"])
            request.startWithCompletionHandler({ (connection, result, error) -> Void in
                if ((error) != nil)
                {
                    // Process error
                    print("Error: \(error)")
                }
                else
                {
                    print(result)
                    self.data.setObject(result.valueForKey("id") as! String, forKey: "UserID")
                    self.data.setObject(result.valueForKey("name") as! String, forKey: "Name")
                    self.data.synchronize()
                    self.getPhoto()
                }
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.data.stringForKey("Name") == nil {
            
        } else {
            print(self.data.stringForKey("Photo"))
            self.performSegueWithIdentifier("LoggedIn", sender: self)
        }
    }
    
    func getPhoto(){
        let url = NSURL(string: "https://avatars.io/facebook/\(self.data.stringForKey("UserID")!)");
        let dataPic = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        self.data.setObject(dataPic, forKey: "Photo")
        self.data.synchronize()
        
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        fetchData()
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "LoggedIn" == segue.identifier{}
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
    
    }

}

    
    
