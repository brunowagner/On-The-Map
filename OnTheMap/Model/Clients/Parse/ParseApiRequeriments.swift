//
//  ParseApiRequeriments.swift
//  OnTheMap
//
//  Created by Bruno W on 28/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import Foundation
class ParseApiRequeriments: ApiRequirements {
    func getUrlScheme() -> String {
        return ParseClient.Constants.ApiScheme
    }
    
    func getUrlHost() -> String {
        return ParseClient.Constants.ApiHost
    }
    
    func getUrlPath() -> String {
        return ParseClient.Constants.ApiPath
    }
    

    func requestConfigToGET(urlRequest: inout NSMutableURLRequest) {
        urlRequest.httpMethod = "GET"
        addDefaultHeader(urlRequest: &urlRequest)
    }
    
    func requestConfigToPOST(urlRequest: inout NSMutableURLRequest, jsonBody : String?) {
        urlRequest.httpMethod = "POST"
        addDefaultHeader(urlRequest: &urlRequest, json: true)
        urlRequest.httpBody = jsonBody?.data(using: String.Encoding.utf8)
    }
    
    func requestConfigToPUT(urlRequest: inout NSMutableURLRequest, jsonBody : String?) {
        urlRequest.httpMethod = "PUT"
        addDefaultHeader(urlRequest: &urlRequest, json: true)
        urlRequest.httpBody = jsonBody?.data(using: String.Encoding.utf8)
    }
    
    func requestConfigToDELET(urlRequest: inout NSMutableURLRequest) {
        urlRequest.httpMethod = "DELETE"
        addDefaultHeader(urlRequest: &urlRequest)
    }
    
    func getValidData(data: Data) -> Data {
        return data
    }
    
    private func addDefaultHeader ( urlRequest: inout NSMutableURLRequest, json : Bool = false){
        urlRequest.addValue(ParseClient.Constants.AppIDValue, forHTTPHeaderField: ParseClient.Constants.AppIDKey)
        urlRequest.addValue(ParseClient.Constants.ApiKeyValue, forHTTPHeaderField: ParseClient.Constants.ApiKeyKey)
        if json {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseApiRequeriments {
        struct Singleton {
            static var sharedInstance = ParseApiRequeriments()
        }
        return Singleton.sharedInstance
    }
        
}
