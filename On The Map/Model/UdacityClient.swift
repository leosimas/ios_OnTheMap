//
//  UdacityClient.swift
//  On The Map
//
//  Created by SoSucesso on 27/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class UdacityClient {
    
    private struct Constants {
        static let URL_SESSION = "https://www.udacity.com/api/session"
        
    }
    
    private struct ParameterKeys {
        static let LIMIT = "limit"
        static let ORDER = "order"
    }
    
    private struct ParameterValues {
        static let LIMIT_DEFAULT = "100"
        static let ORDER_DEFAULT = "-updatedAt"
    }
    
    static private var shared : UdacityClient?
    
    static func sharedInstance() -> UdacityClient {
        if UdacityClient.shared == nil {
            UdacityClient.shared = UdacityClient()
        }
        
        return UdacityClient.shared!
    }
    
    private init() {
    }
    
    private func parseJSON(data : Data) -> [String:AnyObject?]?{
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject?]
        } catch {
            print("Could not parse the data as JSON: '\(data)'")
            return nil
        }
    }
    
    func requestLogin( login : String, password : String, completion : @escaping (( Bool, String? ) -> Void) ) {
        let request = NSMutableURLRequest(url: URL(string: Constants.URL_SESSION)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(login)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completion(false, "Failed to login. Something when wrong.")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            guard let json = self.parseJSON(data: newData!) else {
                completion(false, "Failed to parse JSON")
                return
            }
            
            if let errorMessage = json["error"] as? String {
                completion(false, errorMessage)
                return
            }
            
//            {
//                "account":{
//                    "registered":true,
//                    "key":"3903878747"
//                },
//                "session":{
//                    "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
//                    "expiration":"2015-05-10T16:48:30.760460Z"
//                }
//            }
            
            completion(true, nil)
        }
        task.resume()
    }
    
    func requestLogout(completion : @escaping (( Bool, Error? ) -> Void)) {
        if (FBSDKAccessToken.current() != nil) {
            FBSDKLoginManager().logOut()
            completion(true, nil)
            return
        }
        
        let request = NSMutableURLRequest(url: URL(string: Constants.URL_SESSION)!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completion(false, error)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!)
            
            completion(true, nil)
        }
        task.resume()
    }
    
    private func createBasicUrl() -> URLComponents{
        // https://parse.udacity.com/parse/classes/StudentLocation
        var components = URLComponents()
        components.scheme = "https"
        components.host = "parse.udacity.com"
        components.path = "/parse/classes/StudentLocation"
        return components
    }
    
    private func createRequest(components : URLComponents) -> URLRequest {
        var request = URLRequest(url: components.url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request
    }
    
    func requestStudentsLocations(completion : @escaping (( [StudentInformation]?, String? ) -> Void)) {
        var components = createBasicUrl()
        components.queryItems = [
            URLQueryItem(name: ParameterKeys.LIMIT, value: ParameterValues.LIMIT_DEFAULT),
            URLQueryItem(name: ParameterKeys.ORDER, value: ParameterValues.ORDER_DEFAULT)
        ]
        
        var request = createRequest(components: components)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completion(nil, error?.localizedDescription)
                return
            }
            
            guard let json = self.parseJSON(data: data!) else {
                completion(nil, "Failed to parse JSON")
                return
            }
            
            guard let results = json["results"] as? [[String:AnyObject?]] else {
                completion(nil, "Failed to parse JSON")
                return
            }
            
            var array : [StudentInformation] = []
            for info in results {
                array.append( StudentInformation(json: info) )
            }
            
            completion(array, nil)
        }
        task.resume()
    }
    
}
