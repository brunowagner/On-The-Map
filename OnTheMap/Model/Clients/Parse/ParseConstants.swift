//
//  ParseConstants.swift
//  OnTheMap
//
//  Created by Bruno W on 19/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import Foundation
extension ParseClient{
    
    //MARK: Constants
    struct Constants {
        
        //MARK:
        static let AppIDValue = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKeyValue = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        static let AppIDKey = "X-Parse-Application-Id"
        static let ApiKeyKey = "X-Parse-REST-API-Key"

        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
    }
    
    struct Methods {
        static let FindStudent = "/StudentLocation"
        static let PublishLocation = "/StudentLocation"
        static let UpDateLocation = "/StudentLocation/<objectId>"
        static let DeleteLocation = "/StudentLocation/<objectId>"
    }
    
    struct URLParameters{
        static let ObjectId = "objectId"
    }
    
    struct ParametersKey {
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let Where = "where"
    }
    
    struct JSONKeys {
        
        static let Results = "results"
        
        struct StudentLocation {
            static let   createdAt = "createdAt"
            static let   firstName = "firstName"
            static let   lastName = "lastName"
            static let   latitude = "latitude"
            static let   longitude = "longitude"
            static let   mapString = "mapString"
            static let   mediaURL = "mediaURL"
            static let   objectId = "objectId"
            static let   uniqueKey = "uniqueKey"
            static let   updatedAt = "updatedAt"
        }
        
    }
}
