//
//  ViewController.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 20/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, AuthenticationServiceDelegate {
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewControllerUtils:ViewControllerUtils = ViewControllerUtils();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.borderStyle = UITextBorderStyle.none
        passwordTextField.borderStyle = UITextBorderStyle.none
        ViewControllerUtils().applyBottomBorderOnly(on: emailTextField)
        //applyBottomBorderOnly(on: usernameTextField);
        ViewControllerUtils().applyBottomBorderOnly(on: passwordTextField);
        signinButton.layer.cornerRadius = 20
        signupButton.layer.cornerRadius = 20
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor.white.cgColor
        //signinButton.addTarget(self, action: #selector(ViewController.login(sender:)) , for: .touchUpInside);
    }
    
    @IBAction func signinTouchUpCallback(_ sender: Any) {
        login();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func login() {
        signinButton.isEnabled = false;
        signupButton.isEnabled = false;
        viewControllerUtils.showActivityIndicator(uiView: self.view)
        
        if let email = emailTextField?.text, let password = passwordTextField?.text {
            AuthenticationService.sharedInstance.getChallenge(by: email, password: password, delegate: self)
        }
    }
    
    func didChallenged(challenge: String) {
        if let email = emailTextField?.text{
            AuthenticationService.sharedInstance.verifyChallenge(by: challenge, email:  email, delegate: self);
        }
    }
    
    func challengeDidVerified(token: String) {
        viewControllerUtils.hideActivityIndicator(uiView: self.view)
        signinButton.isEnabled = true;
        signupButton.isEnabled = true;
        performSegue(withIdentifier: "toMeetList", sender: self)
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
        performSegue(withIdentifier: "toMeetList", sender: self)
    }
}

