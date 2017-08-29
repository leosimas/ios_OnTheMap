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
    
    private init() {
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
}
