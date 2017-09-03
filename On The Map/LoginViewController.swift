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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginTextfield: LoginTextField!
    @IBOutlet weak var passwordTextfield: LoginTextField!
    @IBOutlet weak var facebookLoginButton : FBSDKLoginButton!
    @IBOutlet weak var loginButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginTextfield.setPlaceHolder(text: "Login")
        loginTextfield.delegate = self
        
        passwordTextfield.setPlaceHolder(text: "Password")
        passwordTextfield.isSecureTextEntry = true
        passwordTextfield.delegate = self
        
        configureFacebookLoginButton()
        
        if FBSDKAccessToken.current() != nil {
            loginWithFacebook()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }

    @IBAction func loginPressed() {
        func showError(message : String ) {
            DispatchQueue.main.async {
                self.view.endEditing(true)
            }
            Dialogs.alert(controller: self, title: "Ops...", message: message)
        }
        
        guard let login = loginTextfield.text, !login.isEmpty else {
            showError(message: "Type your login")
            return
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            showError(message: "Type your password")
            return
        }
        
        LoadingView.show(inView: view)
        setUIEnabled(false)
        
        StudentManager.sharedInstance().requestLogin(login: login, password: password) { (user, error) in
            
            LoadingView.hide()
            self.setUIEnabled(true)
            
            DispatchQueue.main.async {
                self.passwordTextfield.text = ""
            }
            
            if user == nil {
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
    
    fileprivate func setUIEnabled(_ enabled : Bool) {
        DispatchQueue.main.async {
            self.passwordTextfield.isEnabled = enabled
            self.loginTextfield.isEnabled = enabled
            self.loginButton.isEnabled = enabled
            self.facebookLoginButton.isEnabled = enabled
        }
    }
    
    fileprivate func loginWithFacebook() {
        LoadingView.show(inView: view)
        setUIEnabled(false)
        
        StudentManager.sharedInstance().requestFacebookLogin { (user, error) in
            LoadingView.hide()
            self.setUIEnabled(true)
            
            
            if user == nil {
                FBSDKLoginManager().logOut()
                Dialogs.alert(controller: self, title: "Error", message: error!)
                return
            }
            
            DispatchQueue.main.async {
                self.displayHome()
            }
        }
    }
    
}

extension LoginViewController : FBSDKLoginButtonDelegate {
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if result.isCancelled {
            return
        }
        
        loginWithFacebook()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("facebook logged out")
    }
    
}
// MARK: keyboard events
extension LoginViewController : UITextFieldDelegate  {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextfield {
            passwordTextfield.becomeFirstResponder()
        } else {
            passwordTextfield.resignFirstResponder()
            loginPressed()
        }
        
        return false
    }
    
    func change(height : CGFloat) {
        let oldFrame = view.frame
        
        if height == oldFrame.height {
            return
        }
        
        let frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.width, height: height)
        view.frame = frame
    }
    
    func keyboardWillShow(_ notification:Notification) {
        let newHeight = UIScreen.main.bounds.height - getKeyboardHeight(notification)
        change(height: newHeight)
    }
    
    func keyboardWillHide(_ notification:Notification) {
        change(height: UIScreen.main.bounds.height)
    }
    
    fileprivate func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    fileprivate func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
}
