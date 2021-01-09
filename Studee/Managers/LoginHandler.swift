//  LoginManager.swift
//  Studee
//
//  Created by Navjeeven Mann on 2020-12-29.
//  Copyright © 2020 Navjeeven Mann. All rights reserved.
//

import Foundation
import CryptoKit
import AuthenticationServices
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

protocol LoginProtocol: UIViewController {
    func signedIn()
}

class LoginHandler: NSObject, ASAuthorizationControllerDelegate {
    
    var currentNonce: String?
    weak var delegate: LoginProtocol?
    
    override init() {
        super.init()
        // Set googleSignIn Delegate
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    // MARK: Apple Login Functions
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Make sutre the current Nonce string is not null
            guard currentNonce != nil else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            // get the appleId token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }

            // get tokenString
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential. and Authenticate with firebase
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: currentNonce)
            self.firebaseAuthenticate(credential: credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
    func firebaseAuthenticate(credential: AuthCredential) {
        // Sign in with credential
        Auth.auth().signIn(with: credential, completion: {(_, error) in
            
            if let errorMsg = error?.localizedDescription {
                print(errorMsg)
            } else {
                self.delegate?.signedIn()
            }
        })
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if length == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }

     func getSHA() -> String {
        currentNonce = self.randomNonceString()
        return sha256(currentNonce!)
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    func performAppleLogin() {
        // Generate request to apple and perform the request
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = self.getSHA()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    // MARK: Email Login Functions
    func passwordCheck(passwordString: String) -> Bool {
        // Check if password is longer than 8 characters, has a capital and a number
        var isCapital = false
        var isNum = false
        var index = 0
        let stringArray = Array(passwordString)

        // Loop through the string array  and check conditions
        while index < passwordString.count && !(isCapital && isNum) {
            
            if stringArray[index].isUppercase {
                isCapital = true
            } else if stringArray[index].isNumber {
                isNum = true
            }
            
            index += 1
        }
        // Return all conditions
        return isCapital && isNum && passwordString.count > 8
    }
    
    func emailCheck(emailString: String) -> Bool {
        // Use regex to make sure that the email is valid
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }

    func emailSignUp(email userEmail: String, password userPassword: String, completion: @escaping  (String?) -> Void) {
        // Create a new user using the email and password provided
        // If there is an error pass it using the completion handler
        Auth.auth().createUser(withEmail: userEmail, password: userPassword, completion: { [weak self] (_, error) in
            
            if error != nil {
                completion(error?.localizedDescription)
            } else {
                // Success
                completion(nil)
                self?.delegate?.signedIn()
            }
        })
    }

    func emailLogin(email userEmail: String, password userPassword: String, completion: @escaping (String?) -> Void) {
        // Login a user using the email and password provided
        // If there is an error pass it using the completion handler
        Auth.auth().signIn(withEmail: userEmail, password: userPassword, completion: { [weak self] (_, error) in
            if error != nil {
                completion(error?.localizedDescription)
            } else {
                completion(nil)
                self?.delegate?.signedIn()
            }
        })
    }
}
    // MARK: Google Login Function
extension LoginHandler: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // Login with google and authenticate with firebase with credential
        if  error == nil {
            guard let authentication = user.authentication else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                           accessToken: authentication.accessToken)
            self.firebaseAuthenticate(credential: credential)
        }
        return
    }
}
