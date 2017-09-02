//
//  StudentManager.swift
//  On The Map
//
//  Created by SoSucesso on 28/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

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
    
    private init() {
    }
    
    func requestLogin( login : String, password : String, completion : @escaping (( StudentSession?, String? ) -> Void) ) {
        
        UdacityClient.sharedInstance().requestLogin(login: login, password: password) { (session, error) in
            self.studentSession = session
            
            if error != nil {
                completion(nil, error)
                return
            }
            
            completion(self.studentSession!, error)
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
}
