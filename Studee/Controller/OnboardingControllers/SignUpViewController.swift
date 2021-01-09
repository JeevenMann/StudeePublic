//
//  SignUpViewController.swift
//  Studee
//
//  Created by Navjeeven Mann on 2020-12-28.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import UIKit
import AuthenticationServices
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class SignUpViewController: UIViewController {

    // MARK: IB Outlet/Functions
    @IBOutlet private weak var signUpForm: UIStackView!
    @IBOutlet private weak var signUpView: UIView!
    @IBOutlet private weak var nameField: UITextField!
    @IBOutlet private weak var emailField: UITextField!
    @IBOutlet private weak var passwordField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var googleSignUp: UIButton!
    @IBOutlet private weak var facebookSignUp: UIButton!
    @IBOutlet private weak var socialSignUp: UIStackView!

    @IBAction private func createAccountClick(_ sender: Any) {
        // Check that user has entered a valid email
        // If not present a popup asking for one
        guard let emailText = emailField.text, loginHandler.emailCheck(emailString: emailField.text ?? "") else {
            let popup = PopupView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 15, height: 75), text: "Please enter a valid email.", image: UIImage(systemName: "at.circle.fill")!)
            self.view.addSubview(popup)
            return
        }
        // Check that the user has entered a valid password
        // If not present a popup asking for one
        guard let passText = passwordField.text, loginHandler.passwordCheck(passwordString: passwordField.text ?? "") else {
            let popup = PopupView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 15, height: 75), text: "Please enter a valid password. \nCombine upper and lowercase letters and numbers.", image: UIImage(systemName: "lock.circle.fill")!)
            self.view.addSubview(popup)
            return
        }

        // Sign the user up and handle any errors by displaying it with the popup
        loginHandler.emailSignUp(email: emailText, password: passText, completion: { (errorMsg) in
            if let errorMsg = errorMsg {
                let popup = PopupView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width - 15, height: 75), text: errorMsg, image: UIImage(systemName: "exclamationmark.octagon.fill")!)
                self.view.addSubview(popup)
            }
        })
    }
    
    @IBAction private func facebookClick(_ sender: Any) {
        self.performFBLogin()
    }

    @IBAction private func loginButtonClick(_ sender: Any) {
        // Switch to the login screen
        if let loginVC = self.storyboard?.instantiateViewController(identifier: "loginVC") as? LoginViewController {
            self.navigationController?.setViewControllers([loginVC], animated: true)
        }
    }
    
    @IBAction private func performGoogleLogin(_ sender: Any) {
        // Sign in with google
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
    }

    // MARK: View Variables/Functions
    let loginHandler: LoginHandler = LoginHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegates and add UI elements/constraints
        self.configureUI()
        self.hideKeyboardWhenTappedAround()
        loginHandler.delegate = self
        passwordField.delegate = self
        nameField.delegate = self
        emailField.delegate = self
    }
    
    func performFBLogin() {
        // Declare facebook login manager and ask for permission along with handling the completion
        let login = LoginManager()
        login.logIn(permissions: ["public_profile", "email"], viewController: self, completion: { [weak self] (completion) in
            
            switch completion {

            case .success(granted: _, declined: _, token: let token):
                // Get fb credential and pass to firebase to authenticate
                let fbCredential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                self?.loginHandler.firebaseAuthenticate(credential: fbCredential)
                
            case .cancelled:
                print("Nothing done")
            case .failed:
                print("Nothing done")
            }
        })
    }

    func configureUI() {
        // Declare sign in with apple button
        var appleButton: ASAuthorizationAppleIDButton

        // Depending on the display mode change the button appearance
        if traitCollection.userInterfaceStyle == .light {
            appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .black)
        } else {
            appleButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signUp, authorizationButtonStyle: .white)
        }

        // Insert the button at the first spot in the stackView
        // round button corners
        socialSignUp.insertArrangedSubview(appleButton, at: 0)
        appleButton.layer.cornerRadius = 10
        signUpButton.layer.cornerRadius = 10
        googleSignUp.layer.cornerRadius = 10
        facebookSignUp.layer.cornerRadius = 10

        // add the button target
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
// MARK: Extensions
extension SignUpViewController: LoginProtocol {
    func signedIn() {
        // once signed in present the main tab bar for the user
        guard let tabBar = self.getTB() else {
            return 
        }
        self.navigationController?.setViewControllers([tabBar], animated: true)
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        // based on the tab bar change to the next textfield
        switch textField {
        case nameField:
            emailField.becomeFirstResponder()
        case emailField:
            passwordField.becomeFirstResponder()
        case passwordField:
            textField.resignFirstResponder()
            
        default:
            return true
        }
        
        return true
    }
}
