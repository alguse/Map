//
//  FaccionChooserView.swift
//  Map
//
//  Created by Rodolfo Castillo on 06/03/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import UIKit

class FaccionChooserView: UIViewController {
    
    var ButtonA = UIButton()
    var ButtonB = UIButton()
    var colorManager = ColorPallet()
    var data = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = colorManager.generalColor
        self.ButtonA.backgroundColor = colorManager.faccionA
        self.ButtonB.backgroundColor = colorManager.faccionB
        self.ButtonA.frame.size = CGSize(width: self.view.frame.width/2 - 30, height: self.view.frame.width/2 - 30)
        self.ButtonB.frame.size = self.ButtonA.frame.size
        self.ButtonA.frame.origin.y = self.view.frame.height/2
        self.ButtonB.center = self.ButtonA.center
        
        self.ButtonA.center.x = self.view.frame.width/4 + 5
        self.ButtonB.center.x = self.view.frame.width/4 * 3 - 5
        self.view.addSubview(ButtonA)
        self.view.addSubview(ButtonB)
        self.ButtonB.addTarget(self, action: "escogeB:", forControlEvents: .TouchUpInside)
        self.ButtonA.addTarget(self, action: "escogeA:", forControlEvents: .TouchUpInside)
    }
    
    func escogeA(sender: UIButton){
        self.data.setObject("Charmander", forKey: "Fac")
        self.data.synchronize()
        self.performSegueWithIdentifier("main", sender: sender)
    }
    func escogeB(sender: UIButton){
        self.data.setObject("Squirtle", forKey: "Fac")
        self.data.synchronize()
        self.performSegueWithIdentifier("main", sender: sender)
    }
    
    
}
