//
//  LoginViewController.swift
//  On The Map
//
//  Created by SoSucesso on 27/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextfield: LoginTextField!
    @IBOutlet weak var passwordTextfield: LoginTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginTextfield.setPlaceHolder(text: "Login")
        
        passwordTextfield.setPlaceHolder(text: "Password")
        passwordTextfield.isSecureTextEntry = true
        
    }

    @IBAction func loginPressed(_ sender: Any) {
        // TODO
    }
    
    @IBAction func signUpPressed() {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
