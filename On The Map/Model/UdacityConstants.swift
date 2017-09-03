//
//  UdacityConstants.swift
//  On The Map
//
//  Created by SoSucesso on 03/09/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import Foundation

struct UdacityConstants {
    
    struct UrlPaths {
        static let SESSION = "session"
        static let USER = "users"
    }
    
    struct ParameterKeys {
        static let LIMIT = "limit"
        static let ORDER = "order"
        static let WHERE = "where"
    }
    
    struct ParameterValues {
        static let LIMIT_DEFAULT = "100"
        static let ORDER_DEFAULT = "-updatedAt"
    }
    
    struct ErrorMessages {
        static let PARSE_JSON = "Failed to parse JSON"
    }
    
}
