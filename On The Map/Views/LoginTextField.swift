//
//  LoginTextField.swift
//  On The Map
//
//  Created by SoSucesso on 27/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class LoginTextField: BaseTextField {
    
    static let bgColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5);

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initLoginTextField()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLoginTextField()
    }
    
    private func initLoginTextField() {
        borderStyle = .none
        backgroundColor = LoginTextField.bgColor
        font = UIFont.systemFont(ofSize: 20)
        textColor = UIColor.white
    }

}
