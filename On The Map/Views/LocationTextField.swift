//
//  LocationTextField.swift
//  On The Map
//
//  Created by SoSucesso on 02/09/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class LocationTextField : BaseTextField {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initLocationTextField()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLocationTextField()
    }
    
    private func initLocationTextField() {
        borderStyle = .none
        backgroundColor = UIColor.clear
        font = UIFont.systemFont(ofSize: 18)
        textColor = UIColor.white
    }
    
    
}
