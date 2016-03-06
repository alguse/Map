//
//  ColorPallette.swift
//  Map
//
//  Created by Rodolfo Castillo on 06/03/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import Foundation
import UIKit

class ColorPallet: NSObject {
    
    var data = NSUserDefaults.standardUserDefaults()
    
    var generalColor = UIColor(red: 0.243, green: 0.243, blue: 0.243, alpha: 1)
    //[UIColor colorWithRed:0.243 green:0.243 blue:0.243 alpha:1] 3e3e3e
    var menusColor = UIColor(red: 0.537, green: 0.529, blue: 0.525, alpha: 1)
    //[UIColor colorWithRed:0.537 green:0.529 blue:0.525 alpha:1] #898786
    var faccionA = UIColor(red: 0.918, green: 0.114, blue: 0.141, alpha: 1)
    //[UIColor colorWithRed:0.918 green:0.114 blue:0.141 alpha:1] #EA1D24
    var faccionB = UIColor(red: 0.027, green: 0.824, blue: 0.832, alpha: 1)
    //[UIColor colorWithRed:0.027 green:0.824 blue:0.831 alpha:1] #07D2D4
    
    func getFacColor()->UIColor{
        if data.stringForKey("Fac") != nil {
            if data.stringForKey("Fac")! == "Charmander" {
                return self.faccionA
            } else if data.stringForKey("Fac")! == "Squirtle"{
                return self.faccionB
            } else {
                return self.menusColor
            }
        } else {
            return self.menusColor
        }
    }
    
    
    
}