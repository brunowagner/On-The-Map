//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Bruno W on 21/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import Foundation
extension ParseClient{
    
    func getStudentsLocation(limit : Int, order: String, completionHandlerStudentsLocation : @escaping (_ success : Bool, _ studentsLocation : [StudentLocation]?, _ error : NSError?) -> Void){
        
        let parameters = [
            ParametersKey.Limit : limit,
            ParametersKey.Order : order
            ] as [String : AnyObject]
        
        let _ = HTTPTools.taskForGETMethod(Methods.FindStudent, parameters: parameters, apiRequirements: ParseApiRequeriments.sharedInstance()) { (results, error) in
            
            func sendError(errorCode: Int, errorString: String){
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandlerStudentsLocation(false, nil, NSError(domain: "\(String(describing: self)):getStudentsLocation", code: errorCode, userInfo: userInfo))
            }
            
            guard error == nil else{
                sendError(errorCode: (error?.code)!, errorString: (error?.userInfo.description)!)
                return
            }
            
            guard let results = results?[ParseClient.JSONKeys.Results] as? [[String : AnyObject]] else {
                sendError(errorCode: ErrorTratament.ErrorCode.No_data_or_unexpected_data_was_returned.rawValue ,errorString: "No data or unexpected data was returned by the request!")
                return
            }
            
            let studentsLocation = StudentLocation.studentLocationFromResults(results)
            self.StudentsLocation = studentsLocation
            completionHandlerStudentsLocation(true, studentsLocation,nil)
            
            
            
            
        }//end task
        
    }//end func getStudentsLocation
    
    
    
    func publishLocation(uniqueKey : String , firstName: String, lastName:String,mapString:String,mediaURL:String,latitude: NSNumber,longitude:NSNumber, completionHandlerForPublish: @escaping (_ success : Bool, _ objectId : String?, _ error : NSError?) -> Void){
        
        let parameters = [String : AnyObject]()
        
        let jsonBody = "{\"\(JSONKeys.StudentLocation.uniqueKey)\": \"\(uniqueKey)\", \"\(JSONKeys.StudentLocation.firstName)\": \"\(firstName)\", \"\(JSONKeys.StudentLocation.lastName)\": \"\(lastName)\",\"\(JSONKeys.StudentLocation.mapString)\": \"\(mapString)\", \"\(JSONKeys.StudentLocation.mediaURL)\": \"\(mediaURL)\", \"\(JSONKeys.StudentLocation.latitude)\": \(latitude), \"\(JSONKeys.StudentLocation.longitude)\": \(longitude)}"
        
        let _ = HTTPTools.taskForPOSTMethod(Methods.PublishLocation, parameters: parameters, jsonBody: jsonBody, apiRequirements: ParseApiRequeriments.sharedInstance()) { (results, error) in
            
            func sendError(errorCode: Int, errorString: String){
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandlerForPublish(false, nil, NSError(domain: "\(String(describing: self)):publishLocation", code: errorCode, userInfo: userInfo))
            }
            
            guard error == nil else{
                sendError(errorCode: (error?.code)!, errorString: (error?.userInfo.description)!)
                return
            }
            
            guard let objectId = results?[ParseClient.JSONKeys.StudentLocation.objectId] as? String else{
                sendError(errorCode: ErrorTratament.ErrorCode.No_data_or_unexpected_data_was_returned.rawValue ,errorString: "No data or unexpected data was returned by the request!")
                return
            }
            completionHandlerForPublish(true, objectId, nil)
        }
    }
    
    func updateLocation(objectId : String, studentLocation : StudentLocation , completionHandlerForUpdateLocation : @escaping (_ success : Bool, _ updatedAt : String?, _ error : NSError?) -> Void) {
        
        let parameters = [String : AnyObject]()
        let method = ParseApiRequeriments.sharedInstance().substituteKeyInMethod(method: Methods.UpDateLocation, key: URLParameters.ObjectId, value: objectId)!
        let jsonBody = "{\"\(JSONKeys.StudentLocation.uniqueKey)\": \"\(studentLocation.uniqueKey!)\", \"\(JSONKeys.StudentLocation.firstName)\": \"\(studentLocation.firstName!)\", \"\(JSONKeys.StudentLocation.lastName)\": \"\(studentLocation.lastName!)\",\"\(JSONKeys.StudentLocation.mapString)\": \"\(studentLocation.mapString!)\", \"\(JSONKeys.StudentLocation.mediaURL)\": \"\(studentLocation.mediaURL!)\", \"\(JSONKeys.StudentLocation.latitude)\": \(studentLocation.latitude!), \"\(JSONKeys.StudentLocation.longitude)\": \(studentLocation.longitude!)}"
        
        let _ = HTTPTools.taskForPUTMethod(method, parameters: parameters, jsonBody: jsonBody, apiRequirements: ParseApiRequeriments.sharedInstance()) { (result, error) in
            
            func sendError(errorCode: Int, errorString: String){
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandlerForUpdateLocation(false, nil, NSError(domain: "\(String(describing: self)):updateLocation", code: errorCode, userInfo: userInfo))
            }
            
            guard error == nil else{
                sendError(errorCode: (error?.code)!, errorString: (error?.userInfo.description)!)
                return
            }
            
            guard let updated = result?[ParseClient.JSONKeys.StudentLocation.updatedAt] as? String else {
                sendError(errorCode: ErrorTratament.ErrorCode.No_data_or_unexpected_data_was_returned.rawValue ,errorString: "No data or unexpected data was returned by the request!")
                return
            }
            
            completionHandlerForUpdateLocation(true, updated,nil)
            
            
        }//end task
        
    }
    
    func findPublish(uniqueKey : String? , completionHandlerForFindPublish : @escaping (_ success : Bool, _ studentLocation : StudentLocation?, _ error : NSError?) -> Void) {
        
        guard let uniqueKey = uniqueKey else{
            let userInfo = [NSLocalizedDescriptionKey : "'unikey' can not to be 'nil'"]
            completionHandlerForFindPublish(false, nil, NSError(domain: "\(String(describing: self)):findPublish", code: 400, userInfo: userInfo))
            return
        }
        
        let parameterValue = "{\"uniqueKey\":\"\(uniqueKey)\"}"
        //let parameterValueEscaped = parameterValue
        
        let parameters = [
            ParametersKey.Where : parameterValue,
            ] as [String : AnyObject]
        
        let _ = HTTPTools.taskForGETMethod(Methods.FindStudent, parameters: parameters, apiRequirements: ParseApiRequeriments.sharedInstance()) { (results, error) in
            
            func sendError(errorCode: Int, errorString: String){
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandlerForFindPublish(false, nil, NSError(domain: "\(String(describing: self)):findPublish", code: errorCode, userInfo: userInfo))
            }
            
            guard error == nil else{
                sendError(errorCode: (error?.code)!, errorString: (error?.userInfo.description)!)
                return
            }
            
            guard let results = results?[ParseClient.JSONKeys.Results] as? [[String : AnyObject]] else {
                sendError(errorCode: ErrorTratament.ErrorCode.No_data_or_unexpected_data_was_returned.rawValue ,errorString: "No data or unexpected data was returned by the request!")
                return
            }
            
            // no errors but no register
            if results.count == 0 {
                completionHandlerForFindPublish(true, nil,nil)
            }else{
                let studentLocation = StudentLocation.studentLocationFromResults(results)[0]
                completionHandlerForFindPublish(true, studentLocation,nil)
            }
            
            
        }//end task
        
    }
    
    func removeStudentLocation(objectId : String, completionHandlerStudentsLocation : @escaping (_ success : Bool, _ results : [[String:AnyObject]]?, _ error : NSError?) -> Void){
        
        let parameters = [String : AnyObject]()
        
        let method = ParseApiRequeriments.sharedInstance().substituteKeyInMethod(method: Methods.DeleteLocation, key: URLParameters.ObjectId, value: objectId)!
        
        let _ = HTTPTools.taskForDeleteMethod(method, parameters: parameters, apiRequirements: ParseApiRequeriments.sharedInstance()) { (results, error) in
            
            func sendError(errorCode: Int, errorString: String){
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandlerStudentsLocation(false, nil, NSError(domain: "\(String(describing: self)):getStudentsLocation", code: errorCode, userInfo: userInfo))
            }
            
            guard error == nil else{
                sendError(errorCode: (error?.code)!, errorString: (error?.userInfo.description)!)
                return
            }
            
            self.StudentsLocation = nil
            completionHandlerStudentsLocation(true, nil,nil)
            
            
            
            
        }//end task
        
    }

}
