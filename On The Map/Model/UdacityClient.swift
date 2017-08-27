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
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
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
            
            let response = NSString(data: newData!, encoding: String.Encoding.utf8.rawValue)!
            print(response)
            
            guard let json = self.parseJSON(data: newData!) else {
                completion(false, "Failed to parse JSON")
                return
            }
            
            if let errorMessage = json["error"] as? String {
                completion(false, errorMessage)
                return
            }
            
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
        
        let request = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
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
    
}
