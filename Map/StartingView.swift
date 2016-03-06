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
//    var profilePic = UIImageView()
    var menu = SlidInMenu()
    var map3 = MapView2()
    
    @IBOutlet weak var hiddenbutton: UIButton!
    
    override func viewDidLoad() {
//            setUpProfilPic()
        self.menu.setUp(self)
        self.menu.frame.origin.x = 0 - self.menu.frame.width
        self.menu.frame.origin.y = 0
        self.menu.backgroundColor = UIColor.greenColor()
        self.hiddenbutton.alpha = 1
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        map3.start(screenSize, controler: self)
    }
    
    override func viewDidAppear(animated: Bool) {

        if data.stringForKey("Name") != nil {
            if data.stringForKey("Name") == nil {
                print("ASJDLASJDAS")
                self.performSegueWithIdentifier("login", sender: self)
            } else {
                self.Name = data.stringForKey("Name")
                print(Name)
//                self.profilePic.image = UIImage(data: (self.data.objectForKey("Photo") as! NSData))
            }
            print(Name)
        } else {
            print("asdasdasd")
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
                }, completion: nil)
        }
        
    }
    
    @IBAction func openMenu(){
        self.appearAnimiation(0)
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
    
//    func setUpProfilPic(){
//        self.profilePic.backgroundColor = UIColor.grayColor()
//        self.profilePic.clipsToBounds = true
//        self.profilePic.frame = CGRect(origin: CGPoint(x: self.view.frame.width/2 - 50, y: self.view.frame.height/2 - 50), size: CGSize(width: 100, height: 100))
//        self.profilePic.layer.cornerRadius = self.profilePic.frame.width/2
//        self.view.addSubview(profilePic)
//    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if "Login" == segue.identifier {
            // Nothing really to do here, since it won't be fired unless
            // shouldPerformSegueWithIdentifier() says it's ok. In a real app,
            // this is where you'd pass data to the success view controller.
        }
    }
    
}