//
//  FirebaseDBService.swift
//  Saffy Cleaning
//
//  Created by Mark Chan on 16/3/2022.
//


import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import UIKit


final class FirebaseDBService {
    static let service = FirebaseDBService()
    private let db = Database.database().reference()
    private let user = Auth.auth().currentUser!
    private let storage = Storage.storage().reference()
}

// MARK: Order Mgmt

extension FirebaseDBService {
    public func createNewOrder(value:NSDictionary) {
        let ref = db.child(Constants.userOrders)
        ref.child(user.uid).childByAutoId().setValue(value)
    }
    
    public func retrieveOrder() {
        let ref = db.child(Constants.userOrders).child(user.uid).queryOrdered(byChild: "status").queryEqual(toValue: "pending")
        print("getting order data")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            print (snapshot)
        })
    }
    
    public func retrieveUser(completion: @escaping(User?) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
            
        }
        
    }
    
    public func saveImage(image: UIImage, completion: @escaping(URL?) -> Void) {
        
        let fileName = NSUUID().uuidString
        let databaseRef = db.child("users").child(user.uid)
        let storageRef = storage.child("profileImages").child(fileName)
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error images: \(error.localizedDescription)")
                return
            }
            
            storageRef.downloadURL { url, error in
                
                if let error = error {
                    print("Error downloading url: \(error.localizedDescription)")
                }
                
                guard let imageUrl = url?.absoluteString else { return }
                
                let newData = ["profileImageUrl": imageUrl]
                
                databaseRef.updateChildValues(newData)
                
                completion(url)
                
            }
        }
        
    }
    
}

// MARK: User Mgmt

extension FirebaseDBService {
    public func syncUserType(value: String) {
        let ref = db.child(Constants.userTypes)
        ref.child(user.uid).setValue(["id": user.uid, "email": user.email, "type": value])
    }
}

// MARK: Address Mgmt

extension FirebaseDBService {
    
    public func saveAddress(value:NSDictionary) -> DatabaseReference {
        let ref = db.child(Constants.userAddress)
        let child = ref.child(user.uid).childByAutoId()
        child.setValue(value, withCompletionBlock: {err, _ in
            guard err == nil else{
                print(err.debugDescription)
                return
            }
            print("successfully saved address")
        })
        return child
    }
    
    public func retrieveAddress(completion: @escaping([Address]?) -> Void) {
        var addresses = [Address]()
        addresses = []
        let ref = db.child(Constants.userAddress)
        ref.child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                for key in dict.keys {
                    if let item = dict[key] as? Dictionary<String, Any> {
                        let street = item["street"] ?? ""
                        let postalCode = item["postalCode"] ?? ""
                        let district = item["district"] ?? ""
                        let building = item["building"] ?? ""
                        let type = item["type"] ?? ""
                        let contactPerson = item["contactPerson"] ?? ""
                        let contactNumber = item["contactNumber"] ?? ""
                        let name = item["name"] ?? ""
                        let sizes = item["sizes"] ?? 0
                        let flat = item["flat"] ?? ""
                        let room = item["room"] ?? ""
                        let latitude = item["latitude"] ?? 0
                        let longitude = item["longitude"] ?? 0
                        let images = item["images"] ?? []
                        let createdAt = item["createdAt"] ?? 0
                        print("createdAt\(createdAt)")
                        let newAddress = Address(
                            name: name as! String,
                            room: room as! String,
                            flat: flat as! String,
                            street: street as! String,
                            postalCode: postalCode as! String,
                            building: building as! String,
                            district: district as! String,
                            contactPerson: contactPerson as! String,
                            contactNumber: contactNumber as! String,
                            type: type as! String,
                            sizes: sizes as! String,
                            longitude: longitude as! Double,
                            latitude: latitude as! Double,
                            images: images as! [String],
                            createdAt: String(format: "%.6f", createdAt as! Double)
                        )
                        addresses.append(newAddress)
                    }
                }
                let newAddress = addresses.sorted(by: {$0.createdAt.compare($1.createdAt) == .orderedDescending})
                completion(newAddress)
            }else {
                completion([])
            }
        })
    }
}
