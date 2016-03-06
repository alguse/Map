//
//  StartingView.swift
//  Map
//
//  Created by Rodolfo Castillo on 05/03/16.
//  Copyright © 2016 Sergio Albarran & Rodolfo Castillo. All rights reserved.
//

import Foundation
import UIKit

class StartingView: UIViewController {
    
    var data = NSUserDefaults.standardUserDefaults()
    var Name: String!
//    var profilePic = UIImageView()
    var menu = SlidInMenu()
    var navShape: UILabel!
    var colorManager = ColorPallet()
    var dataForServer : [String: [String:String]]!
    var factione: String!
    var userID: String!
    var rocket = URLrequests()
    
    @IBOutlet weak var hiddenbutton: UIButton!
    
    override func viewDidLoad() {
//            setUpProfilPic()
        self.navShape = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.width, height: 70)))
        self.view.backgroundColor = colorManager.generalColor
        self.view.addSubview(navShape)
        self.view.sendSubviewToBack(navShape)
        self.menu.setUp(self)
        self.menu.frame.origin.x = 0 - self.menu.frame.width
        self.menu.frame.origin.y = 0
        self.menu.alpha = 0
//        self.menu.backgroundColor = UIColor.greenColor()
        self.hiddenbutton.alpha = 0
        self.hiddenbutton.enabled = false
            }
    
    override func viewDidAppear(animated: Bool) {
        self.navShape.backgroundColor = colorManager.getFacColor()
        if data.stringForKey("Name") != nil {
            if data.stringForKey("Name") == nil {
//                print("ASJDLASJDAS")
                self.performSegueWithIdentifier("login", sender: self)
            } else {
                self.Name = data.stringForKey("Name")
                self.userID = data.stringForKey("UserID")
//                self.profilePic.image = UIImage(data: (self.data.objectForKey("Photo") as! NSData))
            }
            if data.stringForKey("Fac") == nil {
                self.performSegueWithIdentifier("faccion", sender: self)
                
            } else {
                self.factione = data.stringForKey("Fac")!
                self.dataForServer = ["user":["name": Name, "fb_id": userID, "faction": factione]]
//                self.rocket.launch("http://162.243.65.37/api/users", params: dataForServer)
                self.rocket.shoot("http://162.243.65.37/api/users/2", params: ["user" : ["points": "1"]])
            }
            print(Name)
            
        } else {
//            print("asdasdasd")
            self.performSegueWithIdentifier("Login", sender: self)
        }

    }
    
    func appearAnimiation(state: Int){
        if state == 0 {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveLinear, animations: {
                self.menu.transform = CGAffineTransformMakeTranslation(self.menu.frame.width, 0)
                }, completion: nil)
        } else{
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .CurveLinear, animations: {
                self.menu.transform = CGAffineTransformIdentity
                self.menu.alpha = 0
                }, completion: nil)
        }
        
    }
    
    @IBAction func openMenu(){
        self.appearAnimiation(0)
        self.menu.alpha = 1
        UIView.animateWithDuration(0.3, animations: {
            self.hiddenbutton.alpha = 1
        })
        self.hiddenbutton.enabled = true
    }
    @IBAction func hideMenu(){
        self.appearAnimiation(1)
        UIView.animateWithDuration(0.5, animations: {
            self.hiddenbutton.alpha = 0
        })
        self.hiddenbutton.enabled = false
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "Login" == segue.identifier {
        }
    }
    
}