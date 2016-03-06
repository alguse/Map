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
    var map3 = MapView2()
    var labelView = UILabel()
    var StopButton : UIButton = UIButton(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 300, height: 60)))
    var searchText: String!
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var textBox: UITextField!

    
    @IBAction func buttnTouched(sender: AnyObject) {
        searchText = textBox.text!
        if self.textBox != nil {
            self.textBox.resignFirstResponder()
        }
        self.map3.searchBarSearchButtonClicked(searchText)
    }
    
    
    @IBOutlet weak var hiddenbutton: UIButton!
    
    override func viewDidLoad() {
//            setUpProfilPic()
        self.searchButton.frame.origin.y = self.view.frame.width - (searchButton.frame.width + 20)
        self.StopButton.setTitle("Terminar", forState: .Normal)
        self.StopButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.StopButton.layer.cornerRadius = 20
        self.StopButton.backgroundColor = UIColor.redColor()
        self.StopButton.center.x = self.view.center.x
        
        self.StopButton.frame.origin.y = self.view.frame.height
        self.StopButton.addTarget(self, action: "StopGame:", forControlEvents: .TouchUpInside)
        self.view.addSubview(StopButton)
        self.labelView.alpha = 0
        self.labelView.backgroundColor = UIColor.blackColor()
        self.labelView.frame.size = CGSize(width: self.view.frame.width/4 * 3, height: self.view.frame.width/4 * 3)
        self.labelView.text = "👍"
        self.labelView.textAlignment = .Center
        self.labelView.font = UIFont(name: "HelveticaNeue", size: 80)
        self.labelView.layer.cornerRadius = self.labelView.frame.width/3
        self.view.addSubview(labelView)
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
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        map3.start(screenSize, controler: self)
        self.view.bringSubviewToFront(StopButton)
        self.view.bringSubviewToFront(searchButton)
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
                self.dataForServer = ["user":["name": Name, "fb_id": userID, "faction": "NONE"]]
//                self.dataForServer = ["user":["name": Name, "fb_id": userID, "faction": factione]]
                self.rocket.launch("http://162.243.65.37/api/users", params: dataForServer)
//                self.profilePic.image = UIImage(data: (self.data.objectForKey("Photo") as! NSData))
            }
//            if data.stringForKey("Fac") == nil {
//                self.performSegueWithIdentifier("faccion", sender: self)
//                
//            } else {
//                self.factione = data.stringForKey("Fac")!
//                
////                self.rocket.launch("http://162.243.65.37/api/users", params: dataForServer)
//                self.rocket.shoot("http://162.243.65.37/api/users/2", params: ["user" : ["points": "1"]])
//            }
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
                if self.textBox != nil {
                self.textBox.resignFirstResponder()
                }
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
    
    func StopGame(sender: UIButton!){
        map3.stopGame()
        print("Time \(map3.getTime())")
    }
    
}