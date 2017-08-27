//
//  LoginViewController.swift
//  On The Map
//
//  Created by SoSucesso on 27/08/17.
//  Copyright © 2017 Leonardo Simas. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextfield: LoginTextField!
    @IBOutlet weak var passwordTextfield: LoginTextField!
    @IBOutlet weak var facebookLoginButton : FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginTextfield.setPlaceHolder(text: "Login")
        
        passwordTextfield.setPlaceHolder(text: "Password")
        passwordTextfield.isSecureTextEntry = true
        
        configureFacebookLoginButton()
    }

    @IBAction func loginPressed(_ sender: Any) {
        guard let login = loginTextfield.text, !login.isEmpty else {
            Alert.alert(controller: self, title: "Ops...", message: "Type your login")
            return
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            Alert.alert(controller: self, title: "Ops...", message: "Type your password")
            return
        }
        
        UdacityClient.sharedInstance().requestLogin(login: login, password: password) { (sucess, error) in
            if !sucess {
                Alert.alert(controller: self, title: "Error", message: error!)
                return
            }
            
            DispatchQueue.main.async {
                self.displayHome()
            }
        }
    }
    
    @IBAction func signUpPressed() {
        let url = URL(string: "https://www.udacity.com/account/auth#!/signup")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func configureFacebookLoginButton() {
        facebookLoginButton.readPermissions = ["public_profile", "email"]
        facebookLoginButton.delegate = self
    }
    
    fileprivate func displayHome() {
        performSegue(withIdentifier: "segueHome", sender: nil)
    }
}

extension LoginViewController : FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if result.isCancelled {
            return
        }
        
        print("facebook logged in")
        displayHome()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("facebook logged out")
    }
    
}
