//
//  UdacitApiRequeriments.swift
//  OnTheMap
//
//  Created by Bruno W on 28/07/2018.
//  Copyright © 2018 Bruno_W. All rights reserved.
//

import Foundation
class UdacityApiRequeriments: ApiRequirements {
    func getUrlScheme() -> String {
        return UdacityClient.Constants.ApiScheme
    }
    
    func getUrlHost() -> String {
        return UdacityClient.Constants.ApiHost
    }
    
    func getUrlPath() -> String {
        return UdacityClient.Constants.ApiPath
    }
    

    func requestConfigToGET(urlRequest: inout NSMutableURLRequest) {
        urlRequest.httpMethod = "GET"
    }
    
    func requestConfigToPOST(urlRequest: inout NSMutableURLRequest, jsonBody: String?) {
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonBody?.data(using: String.Encoding.utf8)
    }
    
    func requestConfigToPUT(urlRequest: inout NSMutableURLRequest, jsonBody: String?) {
        urlRequest.httpMethod = "PUT"
    }
    
    func requestConfigToDELET(urlRequest: inout NSMutableURLRequest) {
        urlRequest.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            urlRequest.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
    }
    
    func getValidData(data: Data) -> Data {
        let range : Range = Range(5..<data.count)
        let newData : Data = data.subdata(in: range)
        return newData
    }
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityApiRequeriments {
        struct Singleton {
            static var sharedInstance = UdacityApiRequeriments()
        }
        return Singleton.sharedInstance
    }
}
