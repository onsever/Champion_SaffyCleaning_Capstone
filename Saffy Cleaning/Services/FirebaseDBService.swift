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
    
    public func retrievePendingOrders(completion: @escaping ([UserOrder]) -> Void) {
//        let ref = db.child(Constants.userOrders).child(user.uid).queryOrdered(byChild: "status").queryEqual(toValue: "pending")
        let ref = db.child(Constants.userOrders)
        var openingOrder = [UserOrder]()
        ref.observeSingleEvent(of: .value, with: { snapshots in
            for snapshot in snapshots.value as! Dictionary<String, Any>  {
                let allOrders = snapshot.value as! Dictionary<String, Any>
                for order in allOrders {
                    let orderDict = order.value as! Dictionary<String, Any>
                    if orderDict["status"] as! String == "pending" {
                        let address = self.convertDictToAddress(item: orderDict["address"] as! Dictionary<String, Any>)
                        let orderObj = self.convertDictToOrder(dict: orderDict, address: address)
                        openingOrder.append(orderObj)
                    }
                }
            }
            completion(openingOrder)
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
    
    private func convertDictToOrder(dict: Dictionary<String, Any>, address: Address) -> UserOrder {
        let date = dict["date"] as? String ?? ""
        let duration = dict["duration"] as? Int ?? 0
        let message = dict["message"] as? String ?? ""
        let pet = dict["pet"] as? String ?? ""
        let selectedItems = dict["selectedItems"] as? [String] ?? []
//        let status = dict["status"] as? String ?? ""
        let time = dict["time"] as? String ?? ""
        let tips = dict["tips"] as? Double ?? 0.0
        let totalCost = dict["totalCost"] as? Double ?? 0.0
//        let workerId = dict["workerId"] as? String ?? ""
        return UserOrder(date: date, time: time, duration: duration, address: address, pet: pet, message: message, selectedItems: selectedItems, tips: tips, totalCost: totalCost)
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
                        let newAddress = self.convertDictToAddress(item: item)
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
    
    private func convertDictToAddress(item: Dictionary<String, Any>) -> Address {
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
        let latitude = item["latitude"] ?? 0.0
        let longitude = item["longitude"] ?? 0.0
        let images = item["images"] ?? []
        let createdAt = item["createdAt"] ?? 0.0
        print("createdAt\(createdAt)")
        return Address(
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
    }
}
