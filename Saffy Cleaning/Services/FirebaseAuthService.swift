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
    
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    func loginWithThirdParties(credential: AuthCredential, completionBlock: @escaping (_ sucess: Bool) -> Void) {
        Auth.auth().signIn(with: credential) {(result, error) in
            if error != nil {
                completionBlock(false)
                return
            }
            if let user = result?.user {
                
                FirebaseDBService.service.retrieveUserById(id: user.uid, completion: { result in
                    
                    if (result == nil){
                        let username = user.email ?? ""
                        let email = user.email ?? ""
                        let fullName = user.displayName ?? ""
                        let userType = UserType.user.rawValue
                        let image = UIImage(systemName: "person.circle")!
                        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
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
                                let dictionary = ["username": username, "fullName": fullName, "email": email, "contactNumber": "", "profileImageUrl": profileImageUrl, "userType": userType]

                                Database.database().reference().child("users").child(user.uid).updateChildValues(dictionary)
                                completionBlock(true)
                            }

                        }
                    }else {
                        completionBlock(true)
                    }
                })
            } else {
                print("no user")
            }
        }
        
    }

    
    
    public func registerUser(with user: Credentials, completion: @escaping(Error?, DatabaseReference?) -> Void) {
        
        let username = user.username
        let fullName = user.fullName
        let email = user.email
        let password = user.password
        let contactNumber = user.contactNumber
        let userType = user.userType
        
        guard let imageData = user.profileImageUrl.jpegData(compressionQuality: 1) else { return }
        
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profileImages").child(fileName)
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            storageRef.downloadURL { url, error in
                
                if let _ = error {
                    return
                }
                
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    
                    if let error = error {
                        completion(error, nil)
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
    
    public func forgetPassword(email: String) {
        print(email)
        Auth.auth().sendPasswordReset(withEmail: email) { err in
            guard err == nil else {
                print(err?.localizedDescription)
                return
            }
        }
    }
    
}
