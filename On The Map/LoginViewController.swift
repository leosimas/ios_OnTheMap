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
    @IBOutlet weak var loginButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginTextfield.setPlaceHolder(text: "Login")
        
        loginTextfield.text = "leo.simas.goncalves@gmail.com"
        
        passwordTextfield.setPlaceHolder(text: "Password")
        passwordTextfield.isSecureTextEntry = true
        
        configureFacebookLoginButton()
    }

    @IBAction func loginPressed(_ sender: Any) {
        guard let login = loginTextfield.text, !login.isEmpty else {
            Dialogs.alert(controller: self, title: "Ops...", message: "Type your login")
            return
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            Dialogs.alert(controller: self, title: "Ops...", message: "Type your password")
            return
        }
        
        LoadingView.show(inView: view)
        setUIEnabled(false)
        
        UdacityClient.sharedInstance().requestLogin(login: login, password: password) { (sucess, error) in
            
            LoadingView.hide()
            self.setUIEnabled(true)
            
            DispatchQueue.main.async {
                self.passwordTextfield.text = ""
            }
            
            if !sucess {
                Dialogs.alert(controller: self, title: "Error", message: error!)
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
    
    private func setUIEnabled(_ enabled : Bool) {
        DispatchQueue.main.async {
            self.passwordTextfield.isEnabled = enabled
            self.loginTextfield.isEnabled = enabled
            self.loginButton.isEnabled = enabled
            self.facebookLoginButton.isEnabled = enabled
        }
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
