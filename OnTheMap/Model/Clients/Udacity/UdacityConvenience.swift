//
//  UdacityConvenience.swift
//  OnTheMap
//
//  Created by Bruno W on 20/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient{
    
    func getUserKey(email : String, password : String, completionHandlerForSession: @escaping (_ success : Bool, _ userKey : String?, _ error : NSError?) -> Void){
        
        let parameters = [String : AnyObject]()
        
        let jsonBody = "{\"\(UdacityClient.JSONBodyKeys.Udacity)\": {\"\(UdacityClient.JSONBodyKeys.UserName)\": \"\(email)\", \"\(UdacityClient.JSONBodyKeys.Password)\": \"\(password)\"}}"

        
        let _ = HTTPTools.taskForPOSTMethod(UdacityClient.Methods.Session, parameters: parameters, jsonBody: jsonBody, apiRequirements: UdacityApiRequeriments.sharedInstance()) { (results, error) in
            
            func sendError(errorCode: Int, errorString: String){
                print(errorString)
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandlerForSession(false, nil, NSError(domain: "\(String(describing: self)):getUserKey", code: errorCode, userInfo: userInfo))
            }
            
            guard error == nil else{
                sendError(errorCode: (error?.code)!, errorString: (error?.userInfo.description)!)
                return
            }
            
            guard let accountDictionary = results?[UdacityClient.JSONResponseKeys.Account] as? [String : AnyObject] else{
                sendError(errorCode: ErrorTratament.ErrorCode.No_data_or_unexpected_data_was_returned.rawValue ,errorString: "Could not get accuntDictionary!")
                return
            }
            
            guard let key = accountDictionary[UdacityClient.JSONResponseKeys.Key] as? String else{
                sendError(errorCode: ErrorTratament.ErrorCode.No_data_or_unexpected_data_was_returned.rawValue ,errorString: "Could not get key account!")
                return
            }
            completionHandlerForSession(true, key, nil)
        }
    }
    
    func findUser(Key : String, completionHandlerForFind: @escaping (_ success : Bool, _ results : [String : AnyObject]?, _ error : NSError?) -> Void){
        
        let parameter = [String : AnyObject]()
        let method = UdacityApiRequeriments.sharedInstance().substituteKeyInMethod(method: Methods.User, key: URLParameters.UserId, value: Key)!
        
        let _ = HTTPTools.taskForGETMethod(method, parameters: parameter, apiRequirements: UdacityApiRequeriments.sharedInstance()) { (results, error) in
            
            func sendError(errorCode: Int, errorString: String){
                print(errorString)
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandlerForFind(false, nil, NSError(domain: "\(String(describing: self)):findUser", code: errorCode, userInfo: userInfo))
            }
            
            guard error == nil else{
                sendError(errorCode: (error?.code)!, errorString: (error?.userInfo.description)!)
                return
            }
            
            guard let userDictionary = results?[UdacityClient.JSONResponseKeys.User] as? [String : AnyObject] else{
                sendError(errorCode: ErrorTratament.ErrorCode.No_data_or_unexpected_data_was_returned.rawValue ,errorString: "Could not get usertDictionary!")
                return
            }
            completionHandlerForFind(true, userDictionary, nil)
        }
        
    }
    
    func login (email : String, password : String, completionHandleLogin : @escaping ( _ success : Bool, _ userKey : String?, _ error : NSError?) -> Void){
        
        getUserKey(email: email, password: password) { (success, userKey, errorString) in
            completionHandleLogin(success, userKey, errorString)
        }
    }
    
    func logout (completionHandleLogout : @escaping ( _ success : Bool, _ results : [String : AnyObject]?, _ error : NSError?) -> Void){
        
        let _ = HTTPTools.taskForDeleteMethod(Methods.Session, parameters: [:], apiRequirements: UdacityApiRequeriments.sharedInstance()) { (results, error) in
            
            func sendError(errorCode: Int, errorString: String){
                print(errorString)
                let userInfo = [NSLocalizedDescriptionKey : errorString]
                completionHandleLogout(false, nil, NSError(domain: "\(String(describing: self)):logout", code: errorCode, userInfo: userInfo))
            }
            
            guard error == nil else{
                sendError(errorCode: (error?.code)!, errorString: (error?.userInfo.description)!)
                return
            }
            
            guard let results = results?[UdacityClient.JSONResponseKeys.Session] as? [String : AnyObject] else{
                sendError(errorCode: ErrorTratament.ErrorCode.No_data_or_unexpected_data_was_returned.rawValue ,errorString: "Could not get sessionDictionary!")
                return
            }
            completionHandleLogout(true, results, nil)
        }
    }
}
