//
//  FirebaseAuthService.swift
//  Saffy Cleaning
//
//  Created by Mark Chan on 10/3/2022.
//

import FirebaseAuth
import Foundation
import GoogleSignIn

class FirebaseAuthService {
    
    static let service = FirebaseAuthService()
    
    static let googleSignConfig = GIDConfiguration.init(clientID: "251466242051-i1a1a4e8e5j3ojhr2bme4u1tn54jjsu4.apps.googleusercontent.com")
    
    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let user = authResult?.user {
                print(user)
                completionBlock(true)
            } else {
                completionBlock(false)
            }
        }
    }
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    func loginWithThirdParties(credential: AuthCredential, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(with: credential, completion: {(firebaseUser, error) in
            completionBlock(error == nil)
        })
    }
    
}
