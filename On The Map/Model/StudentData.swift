//
//  StudentData.swift
//  On The Map
//
//  Created by SoSucesso on 03/09/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import Foundation

class StudentData {
    
    static private var shared : StudentData?
    
    static func sharedInstance() -> StudentData {
        if StudentData.shared == nil {
            StudentData.shared = StudentData()
        }
        
        return StudentData.shared!
    }
    
    var infoArray : [StudentInformation] = []
    
}
