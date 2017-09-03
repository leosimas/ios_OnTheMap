//
//  StudentManager.swift
//  On The Map
//
//  Created by SoSucesso on 28/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import FBSDKLoginKit

class StudentManager {
    
    static private var shared : StudentManager?
    
    static func sharedInstance() -> StudentManager {
        if StudentManager.shared == nil {
            StudentManager.shared = StudentManager()
        }
        
        return StudentManager.shared!
    }
    
    private(set) var infoArray : [StudentInformation] = []
    private(set) var studentLastInfo : StudentInformation? = nil
    private(set) var studentSession : StudentSession? = nil
    private(set) var user : User? = nil
    
    private init() {
    }
    
    func requestFacebookLogin(completion : @escaping (( User?, String? ) -> Void) ) {
        UdacityClient.sharedInstance().requestLoginWithFacebook { (session, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            
            self.studentSession = session
            
            self.requestUserData(completion: { (user, error) in
                completion(user, error)
            })
        }
    }
    
    func requestLogin( login : String, password : String, completion : @escaping (( User?, String? ) -> Void) ) {
        
        UdacityClient.sharedInstance().requestLogin(login: login, password: password) { (session, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            
            self.studentSession = session
            
            self.requestUserData(completion: { (user, error) in
                completion(user, error)
            })
        }
        
    }
    
    func requestLogout(completion : @escaping ((Bool, String?) -> Void)) {
        UdacityClient.sharedInstance().requestLogout { (completed, error) in
            if error != nil {
                completion(false, error!.localizedDescription)
                return
            }
            
            self.studentSession = nil
            self.user = nil
            
            if (FBSDKAccessToken.current() != nil) {
                FBSDKLoginManager().logOut()
                completion(true, nil)
                return
            }
            
            completion(true, nil)
        }
    }
    
    private func requestUserData(completion : @escaping ((User?, String?) -> Void)) {
        UdacityClient.sharedInstance().requestCurrentUserData { (user, error) in
            if error != nil {
                completion(nil, error)
                return
            }
            
            self.user = user
            completion(user, nil)
        }
    }
    
    func requestStudentsInformations(completion : @escaping (([StudentInformation]?, String?) -> Void)) {
        UdacityClient.sharedInstance().requestStudentsLocations { (array, errorMessage) in
            if errorMessage != nil {
                completion(nil, errorMessage)
                return
            }
            
            self.infoArray = array!
            completion(self.infoArray, nil)
        }
    }
    
    func requestCurrentStudentLocation(completion : @escaping ((StudentInformation?, String?) -> Void)) {
        UdacityClient.sharedInstance().requestLocation(forStudent: studentSession!.key) { (info, errorMessage) in
            if errorMessage != nil {
                completion(nil, errorMessage)
                return
            }
            
            self.studentLastInfo = info
            completion(self.studentLastInfo, nil)
        }
        
    }
    
    func requestUpdateLocation(newInfo : StudentInformation, completion : @escaping ((StudentInformation?, String?) -> Void)) {
        
        var newInfo = newInfo
        newInfo.objectId = studentLastInfo == nil ? "" : studentLastInfo!.objectId
        newInfo.firstName = user!.firstName
        newInfo.lastName = user!.lastName
        newInfo.uniqueKey = studentSession!.key
        
        UdacityClient.sharedInstance().saveStudentLocation(studentInfo: newInfo) { (updatedInfo, errorMessage) in
            
            if errorMessage != nil {
                completion(nil, errorMessage)
                return
            }
            
            self.studentLastInfo = updatedInfo
            completion(self.studentLastInfo, nil)
            
        }
    }
    
}
