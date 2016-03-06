//
//  funcions.swift
//  Map
//
//  Created by Sergio Albarran on 02/03/16.
//  Copyright © 2016 Sergio Albarran. All rights reserved.
//

import Foundation
import CoreData
import SystemConfiguration

var url = "http://www.m4gic.info/app/F753Y.php?act="

public class Reach {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, UnsafePointer($0))
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        
        return isReachable && !needsConnection
        
    }
}


public class URLrequests{
    
    func getEvents(action : String, id_event : Int?, completion: (result: NSDictionary?, error: NSError?)->()){
        var query : String = url+action
        if id_event != nil{
            query = query+"&id_event=\(id_event!)"
        }
        let URL = NSURL(string: query)!
        let request = NSMutableURLRequest(URL:URL)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            if error != nil {
                completion(result: nil, error: error)
            } else {
                do{
                    let jsonObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                    completion(result: jsonObject, error: nil)
                }catch {
                    print("Error Json: \(error)")
                }
            }
        }
        task.resume()
    }
}
