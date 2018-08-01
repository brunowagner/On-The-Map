//
//  UserDataUdacity.swift
//  OnTheMap
//
//  Created by Bruno W on 24/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import Foundation
struct UserDataUdacity {
    
     var key : String
     var firstName : String
     var lastName : String
    
    init(dictionary : [String :AnyObject]) {
        self.key = dictionary[UdacityClient.JSONResponseKeys.Key] as! String
        self.firstName = dictionary[UdacityClient.JSONResponseKeys.FirstName] as! String
        self.lastName = dictionary[UdacityClient.JSONResponseKeys.LastName] as! String
    }
}
