//
//  LastSwipeViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2021-01-01.
//  Copyright © 2021 Navjeeven Mann. All rights reserved.
//

import UIKit

class LastSwipeViewController: UIViewController {
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 8
        signupButton.layer.cornerRadius = 8
    }
    
    // Load corresponding screens
    @IBAction private func loginClick(_ sender: Any) {
        if let loginVC = storyboard?.instantiateViewController(identifier: "loginVC") as? LoginViewController {
            self.navigationController?.setViewControllers([loginVC], animated: true)
        }
    }
    @IBAction func signupClick(_ sender: Any) {
        if let signupVC = storyboard?.instantiateViewController(identifier: "signupVC") as? SignUpViewController {
            self.navigationController?.setViewControllers([signupVC], animated: true)
        }
    }
}
