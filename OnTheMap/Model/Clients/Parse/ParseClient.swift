//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Bruno W on 19/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import Foundation
class ParseClient : NSObject {
    
    var StudentsLocation : [StudentLocation]!
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
