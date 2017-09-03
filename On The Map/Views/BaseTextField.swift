//
//  BaseTextField.swift
//  On The Map
//
//  Created by SoSucesso on 02/09/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class BaseTextField : UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 4)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    func setPlaceHolder(text : String?) {
        guard let text = text else {
            attributedPlaceholder = nil
            return
        }
        
        attributedPlaceholder = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
}
