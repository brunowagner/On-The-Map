//
//  ParseStudentLocation.swift
//  OnTheMap
//
//  Created by Bruno W on 20/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import Foundation
struct StudentLocation {
    
    //MARK: Properties
    
    let   createdAt : Date!
    let   firstName : String!
    let   lastName : String!
    var   latitude : NSNumber!
    var   longitude : NSNumber!
    var   mapString : String!
    var   mediaURL : String!
    let   objectId : String!
    let   uniqueKey : String!
    let   updatedAt : Date!
    
    init(dictionary : [String :AnyObject]) {
//        usado para debug
//        for (key , val) in dictionary{
//            print("\(key): \(val)")
//        }
        
        createdAt =  StudentLocation.convertData(DataString: dictionary[ParseClient.JSONKeys.StudentLocation.createdAt] as! String)!
        firstName = dictionary[ParseClient.JSONKeys.StudentLocation.firstName] as? String
        lastName = dictionary[ParseClient.JSONKeys.StudentLocation.lastName] as? String
        latitude = dictionary[ParseClient.JSONKeys.StudentLocation.latitude] as? NSNumber
        longitude = dictionary[ParseClient.JSONKeys.StudentLocation.longitude] as? NSNumber
        mapString = dictionary[ParseClient.JSONKeys.StudentLocation.mapString] as? String
        mediaURL = dictionary[ParseClient.JSONKeys.StudentLocation.mediaURL] as? String
        objectId = dictionary[ParseClient.JSONKeys.StudentLocation.objectId] as? String
        uniqueKey = dictionary[ParseClient.JSONKeys.StudentLocation.uniqueKey] as? String
        updatedAt = StudentLocation.convertData(DataString: dictionary[ParseClient.JSONKeys.StudentLocation.updatedAt] as! String)!
    }
    
    static func studentLocationFromResults(_ results: [[String:AnyObject]]) -> [StudentLocation] {
        
        var studentLocation = [StudentLocation]()
        
        // iterate through array of dictionaries, each StudentLocation is a dictionary
        for result in results {
            if StudentLocation.isInvalidData(dictionary: result) == false{
                studentLocation.append(StudentLocation(dictionary: result))
            }
        }
        
        return studentLocation
    }
    
    static func convertData(DataString : String) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: DataString ) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        return date
    }
    
    static func isInvalidData(dictionary : [String :AnyObject]) -> Bool{
        guard dictionary[ParseClient.JSONKeys.StudentLocation.latitude] as? NSNumber != nil else{
            return true
        }
        guard dictionary[ParseClient.JSONKeys.StudentLocation.longitude] as? NSNumber != nil else{
            return true
        }
        guard dictionary[ParseClient.JSONKeys.StudentLocation.uniqueKey] as? String != nil else{
            print(dictionary[ParseClient.JSONKeys.StudentLocation.uniqueKey] as Any )
            
            return true
        }
        return false
    }

}

// MARK: - TMDBMovie: Equatable

extension StudentLocation: Equatable {}

func ==(lhs: StudentLocation, rhs: StudentLocation) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
}
