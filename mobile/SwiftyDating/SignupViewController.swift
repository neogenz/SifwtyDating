//
//  SignupViewController.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 21/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, AuthenticationServiceDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    var viewControllerUtils:ViewControllerUtils = ViewControllerUtils();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.borderStyle = UITextBorderStyle.none
        passwordTextField.borderStyle = UITextBorderStyle.none
        usernameTextField.borderStyle = UITextBorderStyle.none
        ViewControllerUtils().applyBottomBorderOnly(on: emailTextField)
        ViewControllerUtils().applyBottomBorderOnly(on: usernameTextField)
        ViewControllerUtils().applyBottomBorderOnly(on: passwordTextField)
        signinButton.layer.cornerRadius = 20
        signupButton.layer.cornerRadius = 20
        signinButton.layer.borderWidth = 1
        signinButton.layer.borderColor = UIColor.white.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupButtonTouchUpInsideCallback(_ sender: Any) {
        signinButton.isEnabled = false;
        signupButton.isEnabled = false;
        viewControllerUtils.showActivityIndicator(uiView: self.view)
        if let email = emailTextField?.text, let username = usernameTextField?.text, let password = passwordTextField?.text{
            AuthenticationService.sharedInstance.signup(by: email, username: username, password: password, delegate: self)
        }
    }
    
    
    func didChallenged(challenge: String) {
        
    }
    
    func challengeDidVerified(token: String) {
        
    }
    
    func didFail(UXMessage:String) {
        viewControllerUtils.hideActivityIndicator(uiView: self.view)
        viewControllerUtils.showDialog(uiView: self, message: UXMessage, title: "Erreur", buttonText: "Ressayer")
        signinButton.isEnabled = true;
        signupButton.isEnabled = true;
    }
    
    func didSignedUp(token: String) {
        viewControllerUtils.hideActivityIndicator(uiView: self.view)
        signinButton.isEnabled = true;
        signupButton.isEnabled = true;
        performSegue(withIdentifier: "signupToMeetList", sender: self)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
