//  LoginViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2020-12-29.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import UIKit
import TweeTextField
import AuthenticationServices
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: IB Outlet/Functions
    @IBOutlet private weak var emailField: TweeActiveTextField!
    @IBOutlet private weak var passwordField: TweeActiveTextField!
    @IBOutlet private weak var signInView: UIView!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var googleLogin: UIButton!
    @IBOutlet private weak var socialLogin: UIStackView!
    @IBOutlet private weak var facebookLogin: UIButton!
    
    @IBAction private func loginAccountClick(_ sender: Any) {
        // Check to make sure that the user has entered a valid email
        // If not present a popup asking them to
        guard let emailText = emailField.text, loginHandler.emailCheck(emailString: emailField.text ?? "") else {
            let popup = PopupView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 15, height: 75), text: "Please enter a valid email.", image: UIImage(systemName: "at.circle.fill")!)
            self.view.addSubview(popup)
            return
        }
        
        // Check to make sure that the user has entered a valid email
        // If not present a popup asking them to
        guard let passText = passwordField.text, passwordField.hasText else {
            let popup = PopupView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 15, height: 75), text: "Please enter a password.", image: UIImage(systemName: "lock.circle.fill")!)
            self.view.addSubview(popup)
            return
        }
        
        // Try to sign the user in
        // If an error occurs present a popup with the error message
        loginHandler.emailLogin(email: emailText, password: passText, completion: { (errorMsg) in
            if let errorMsg = errorMsg {
                let popup = PopupView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 15, height: 75), text: errorMsg, image: UIImage(systemName: "exclamationmark.octagon.fill")!)
                self.view.addSubview(popup)
            }
        })
    }
    
    @IBAction private func signUpButtonClick(_ sender: Any) {
        // Safely create the signup vc and present the page
        if let signupVC = storyboard?.instantiateViewController(identifier: "signupVC") as? SignUpViewController {
            self.navigationController?.setViewControllers([signupVC], animated: true)
        }
    }
    
    @IBAction private func facebookClick(_ sender: Any) {
        self.performFBLogin()
    }
    
    @IBAction private func googleLoginClick(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    // MARK: View Variables & Functions
    
    let loginHandler: LoginHandler = LoginHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the UI and set delegates
        self.configureUI()
        self.hideKeyboardWhenTappedAround()
        loginHandler.delegate = self
        passwordField.delegate = self
        emailField.delegate = self
    }
    
    func performFBLogin() {
        // Init facebook login manager and ask for permission for profile and email
        let login = LoginManager()
        login.logIn(permissions: ["public_profile", "email"], viewController: self, completion: { [weak self] (completion) in
            
            // Route the completion with success and get the fb login credential and pass it to firebase
            switch completion {
            case .success(granted:  _, declined:  _, token: let token):
                let fbCredential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                self?.loginHandler.firebaseAuthenticate(credential: fbCredential)
            case .cancelled:
                print("Nothing done")
            case .failed:
                // Put alert that it failed
                print("Nothing done")
            }
        })
    }
    
    func configureUI() {
        var appleButton: ASAuthorizationAppleIDButton
        
        // Based on the users display settings display a dark or light button
        if traitCollection.userInterfaceStyle == .light {
            appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .black)
        } else {
            appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
        }
        
        // insert the SIWA button and round button corners
        // and add appleButton target
        socialLogin.insertArrangedSubview(appleButton, at: 0)
        signInButton.layer.cornerRadius = 10
        googleLogin.layer.cornerRadius = 10
        facebookLogin.layer.cornerRadius = 10
        socialLogin.insertArrangedSubview(appleButton, at: 0)
        appleButton.layer.cornerRadius = 10
        appleButton.addTarget(nil, action: #selector(performAppleLogin), for: .touchUpInside)
        
        // create constraints and activate them
        let heightConstraint = NSLayoutConstraint(item: appleButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        let widthConstraint = NSLayoutConstraint(item: appleButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        NSLayoutConstraint.activate([heightConstraint, widthConstraint])
    }
    
    @objc func performAppleLogin() {
        loginHandler.performAppleLogin()
    }
}
// MARK: Extension
extension LoginViewController: LoginProtocol {
    // Once the user is signed in present the TB
    func signedIn() {
        guard let tabBar = self.getTB() else {
            return 
        }
        tabBar.selectedIndex = 1
        self.navigationController?.setViewControllers([tabBar], animated: true)
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Return the next textfield to present
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
