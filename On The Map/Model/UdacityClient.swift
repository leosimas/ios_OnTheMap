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
    
    var studentSession : StudentSession? = nil
    
    private init() {
    }
    
    private func createLocationsUrl() -> URLComponents{
        // https://parse.udacity.com/parse/classes/StudentLocation
        var components = URLComponents()
        components.scheme = "https"
        components.host = "parse.udacity.com"
        components.path = "/parse/classes/StudentLocation"
        return components
    }
    
    private func createUdacityUrl() -> URLComponents {
        //https://www.udacity.com/api
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.udacity.com"
        components.path = "/api"
        return components
    }
    
    private func createRequest(components : URLComponents) -> URLRequest {
        var request = URLRequest(url: components.url!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request
    }
    
    private func createWhereValue(studentKey : String) -> String {
        return "{\"uniqueKey\":\"\(studentKey)\"}"
    }
    
    private func toJson(info : StudentInformation) -> String {
        return "{\"uniqueKey\": \"\(studentSession!.key)\", \"firstName\": \"\(info.firstName)\", \"lastName\": \"\(info.lastName)\",\"mapString\": \"\(info.mapString)\", \"mediaURL\": \"\(info.mediaURL)\",\"latitude\": \(info.latitude), \"longitude\": \(info.longitude)}"
    }
    
    private func parseJSON(data : Data) -> [String:AnyObject?]?{
        do {
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject?]
        } catch {
            print("Could not parse the data as JSON: '\(data)'")
            return nil
        }
    }
    
    private func parseResultArray(data : Data) -> [[String:AnyObject?]]?{
        guard let json = self.parseJSON(data: data) else {
            return nil
        }
        
        guard let results = json["results"] as? [[String:AnyObject?]] else {
            return nil
        }
        
        return results
    }
    
    func requestLoginWithFacebook(completion : @escaping (( StudentSession?, String? ) -> Void) ) {
        login(login: nil, password: nil, completion: completion)
    }
    
    func requestLogin( login : String, password : String, completion : @escaping (( StudentSession?, String? ) -> Void) ) {
        self.login(login: login, password: password, completion: completion)
    }
    
    private func login( login : String?, password : String?, completion : @escaping (( StudentSession?, String? ) -> Void) ) {
        var components = createUdacityUrl()
        components.path += "/" + UdacityConstants.UrlPaths.SESSION
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if login != nil && password != nil {
            request.httpBody = "{\"udacity\": {\"username\": \"\(login!)\", \"password\": \"\(password!)\"}}".data(using: String.Encoding.utf8)
        } else {
            request.httpBody = "{\"facebook_mobile\": {\"access_token\": \"\(FBSDKAccessToken.current().tokenString!)\"}}".data(using: String.Encoding.utf8)
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completion(nil, "Failed to login. Something when wrong.")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            guard let json = self.parseJSON(data: newData!) else {
                completion(nil, UdacityConstants.ErrorMessages.PARSE_JSON)
                return
            }
            
            if let errorMessage = json["error"] as? String {
                completion(nil, errorMessage)
                return
            }
            
            self.studentSession = StudentSession(json : json)
            completion(self.studentSession, nil)
        }
        task.resume()
    }
    
    func requestLogout(completion : @escaping (( Bool, Error? ) -> Void)) {
        var components = createUdacityUrl()
        components.path += "/" + UdacityConstants.UrlPaths.SESSION
        
        var request = URLRequest(url: components.url!)
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
            
            self.studentSession = nil
            completion(true, nil)
        }
        task.resume()
    }
    
    func requestStudentsLocations(completion : @escaping (( [StudentInformation]?, String? ) -> Void)) {
        var components = createLocationsUrl()
        components.queryItems = [
            URLQueryItem(name: UdacityConstants.ParameterKeys.LIMIT, value: UdacityConstants.ParameterValues.LIMIT_DEFAULT),
            URLQueryItem(name: UdacityConstants.ParameterKeys.ORDER, value: UdacityConstants.ParameterValues.ORDER_DEFAULT)
        ]
        
        var request = createRequest(components: components)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completion(nil, error?.localizedDescription)
                return
            }
            
            guard let results = self.parseResultArray(data: data!) else {
                completion(nil, UdacityConstants.ErrorMessages.PARSE_JSON)
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
    
    func requestLocation(forStudent key : String, completion : @escaping (( StudentInformation?, String? ) -> Void)) {
        var components = createLocationsUrl()
        components.queryItems = [
            URLQueryItem(name: UdacityConstants.ParameterKeys.WHERE, value: createWhereValue(studentKey: key))
        ]
        
        var request = createRequest(components: components)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completion(nil, error?.localizedDescription)
                return
            }
            
            guard let results = self.parseResultArray(data: data!) else {
                completion(nil, UdacityConstants.ErrorMessages.PARSE_JSON)
                return
            }
            
            if (results.count > 0) {
                completion(StudentInformation(json : results[0]), nil)
            } else {
                completion(nil, nil)
            }
        }
        task.resume()
    }
    
    func saveStudentLocation(studentInfo : StudentInformation, completion: @escaping (( StudentInformation?, String? ) -> Void)) {
        var components = createLocationsUrl()
        if !studentInfo.objectId.isEmpty {
            components.path += "/" + studentInfo.objectId
        }
        
        var request = createRequest(components: components)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = toJson(info: studentInfo).data(using: .utf8)
        request.httpMethod = studentInfo.objectId.isEmpty ? "POST" : "PUT"
        
        var studentInfo = studentInfo
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completion(nil, error!.localizedDescription)
                return
            }
            
            print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
            
            guard let json = self.parseJSON(data: data!) else {
                completion(nil, UdacityConstants.ErrorMessages.PARSE_JSON)
                return
            }
            
            guard let _ = json["updatedAt"] as? String else {
                completion(nil, "Could not update your location")
                return
            }
            
            if studentInfo.objectId == "" {
                guard let objectId = json["objectId"] as? String else {
                    completion(nil, "Could not update your location")
                    return
                }
                
                studentInfo.objectId = objectId
            }

            completion(studentInfo, nil)
        }
        task.resume()
    }
    
    func requestCurrentUserData(completion : @escaping ((User?, String?) -> Void)) {
        var components = createUdacityUrl()
        components.path += "/" + UdacityConstants.UrlPaths.USER + "/" + studentSession!.key
        
        var request = createRequest(components: components)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                completion(nil, error!.localizedDescription)
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            guard let json = self.parseJSON(data: newData!) else {
                completion(nil, UdacityConstants.ErrorMessages.PARSE_JSON)
                return
            }
            
            guard let userJson = json["user"] as? [String:AnyObject?] else {
                completion(nil, "Could not get your data")
                return
            }
            
            completion(User(json: userJson), nil)
        }
        task.resume()
    }
}
