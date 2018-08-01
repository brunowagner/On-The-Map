//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Bruno W on 20/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

extension UdacityClient{
    
    //MARK: Constants
    struct Constants {
        
        //MARK: constants
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct Methods {
        static let Session = "/session"
        static let User = "/users/<user_id>"
    }
    
    struct URLParameters{
        static let UserId = "user_id"
    }
    
    
    struct JSONBodyKeys {
        
        static let Udacity = "udacity"
        static let UserName = "username"
        static let Password = "password"
    }
    struct JSONResponseKeys {
        static let Account = "account"
        static let Registered = "registered"
        static let Key = "key"
        static let Session = "session"
        static let Id = "id"
        static let Expiration = "expiration"
        static let User = "user"
        static let LastName = "last_name"
        static let FirstName = "first_name"
    }

}
