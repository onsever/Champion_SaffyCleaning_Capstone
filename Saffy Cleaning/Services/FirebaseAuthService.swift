//
//  FirebaseAuthService.swift
//  Saffy Cleaning
//
//  Created by Mark Chan on 10/3/2022.
//

import GoogleSignIn
import Firebase

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
    
    public func registerUser(with user: Credentials, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        let username = user.username
        let fullName = user.fullName
        let email = user.email
        let password = user.password
        let contactNumber = user.contactNumber
        let userType = user.userType
        
        guard let imageData = user.profileImageUrl.jpegData(compressionQuality: 0.8) else { return }
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profileImages").child(fileName)
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            storageRef.downloadURL { url, error in
                
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let dictionary = ["username": username, "fullName": fullName, "email": email, "contactNumber": contactNumber, "profileImageUrl": profileImageUrl, "userType": userType]
                    
                    Database.database().reference().child("users").child(uid).updateChildValues(dictionary, withCompletionBlock: completion)
                    
                }
                
            }
            
        }
        
    }
    
}
