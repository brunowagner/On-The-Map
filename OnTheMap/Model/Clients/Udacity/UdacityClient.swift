//
//  Client.swift
//  OnTheMap
//
//  Created by Bruno W on 20/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import Foundation
class UdacityClient : NSObject {
    
    // MARK: Properties
    var userDataUdacity : UserDataUdacity!
    var userKey : String? = nil
    

    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient {
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
}
