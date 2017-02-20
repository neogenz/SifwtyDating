//
//  ViewController.swift
//  SwiftyDating
//
//  Created by Maxime De Sogus on 20/02/2017.
//  Copyright © 2017 Maxime De Sogus. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBottomBorderOnly(on: emailTextField)
        applyBottomBorderOnly(on: usernameTextField);
        applyBottomBorderOnly(on: passwordTextField);
        signinButton.layer.cornerRadius = 20
        //signinButton.layer.borderWidth = 2
        //signinButton.layer.borderColor = UIColor(red: 234/255, green: 26/255, blue: 98/255, alpha: 1.0).cgColor
        
        signupButton.layer.cornerRadius = 20
        signupButton.layer.borderWidth = 1
        signupButton.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func applyBottomBorderOnly(on uiControl: UIControl){
        var border:CALayer = CALayer()
        var borderWidth:CGFloat = 1
        border.borderColor = UIColor.white.cgColor;
        border.frame = CGRect(x: 0, y: uiControl.frame.size.height - borderWidth, width: uiControl.frame.size.width, height: uiControl.frame.size.height);
        border.borderWidth = borderWidth;
        uiControl.layer.addSublayer(border)
        uiControl.layer.masksToBounds = true;
    }


}

