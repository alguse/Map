//
//  Menu.swift
//  Map
//
//  Created by Rodolfo Castillo on 06/03/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import Foundation
import UIKit

class SlidInMenu: UIView {
    var profilePic = UIImageView()
    var userName = UILabel()
    var logOutButton = UIButton()
    var sessionManager = FBSDKLoginManager()
    var data = NSUserDefaults.standardUserDefaults()
    var control: UIViewController!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
    }
    
    func setUp(controller: UIViewController){
        self.control = controller
        self.frame.size = CGSize(width: controller.view.frame.width/2, height: controller.view.frame.height)
        controller.view.addSubview(self)
        self.layer.shadowColor = UIColor.darkGrayColor().CGColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSizeZero
        self.logOutButton.frame = CGRect(origin: (CGPoint(x: 0, y: Int(self.frame.height - 100))), size: CGSize(width: self.frame.width, height: 100))
        self.logOutButton.addTarget(self, action: "Logout:", forControlEvents: .TouchUpInside)
        
        self.logOutButton.setTitle("LogOut", forState: .Normal)
        self.logOutButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        self.addSubview(logOutButton)
        self.profilePic.backgroundColor = UIColor.grayColor()
        self.profilePic.clipsToBounds = true
        self.profilePic.frame = CGRect(origin: CGPoint(x: self.frame.width/2 - 50, y: 0 + 30), size: CGSize(width: 100, height: 100))
        self.profilePic.layer.cornerRadius = self.profilePic.frame.width/2
        self.addSubview(profilePic)
        self.userName.frame = CGRect(origin: (CGPoint(x: 0, y: 10 + self.profilePic.frame.height)), size: CGSize(width: self.frame.width, height: 100))
        self.userName.text = self.data.stringForKey("Name")
        self.addSubview(userName)
        self.userName.textAlignment = .Center
        if data.objectForKey("Photo") != nil {
            profilePic.image = UIImage(data: (data.objectForKey("Photo") as! NSData))
            
        }
    
    }

    func Logout(sender: UIButton!){
        if self.data.objectForKey("Name") != nil {
            sessionManager.logOut()
            print("LoggedOff")
            self.data.setObject(nil , forKey: "Name")
            self.control.performSegueWithIdentifier("Login", sender: self.logOutButton)
        } else {
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var manager = FBSDKLoginManager()
    
}