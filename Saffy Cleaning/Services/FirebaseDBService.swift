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
    private let user = Auth.auth().currentUser
    private let storage = Storage.storage().reference()
}

// MARK: Review Mgmt {
extension FirebaseDBService {
    public func retrieveReviews(type: String, completion: @escaping([Review]) -> Void) {
        let isUser = type == UserType.user.rawValue ? true : false
        let ref = db.child(Constants.reviews).child(user!.uid)
        var reviews = [Review]()
        ref.observeSingleEvent(of: .value) { snapshot in
            guard snapshot.exists() else { return }
            for item in snapshot.value as! Dictionary<String, Any> {
                let itemDict = item.value as! Dictionary<String, Any>
                let date = itemDict["date"] ?? ""
                let reviewerId = itemDict["reviewerId"] ?? ""
                let reviewerImageUrl = itemDict["reviewerImageUrl"] ?? ""
                let info = itemDict["info"] ?? ""
                let ratingCount = itemDict["ratingCount"] ?? 0
                let revieweeUserType = itemDict["revieweeUserType"] ?? UserType.user.rawValue
                let newReview = Review(reviewerId: reviewerId as! String, date: date as! String, info: info as! String, ratingCount: ratingCount as! Int, revieweeUserType: revieweeUserType as! String, reviewerImageUrl: reviewerImageUrl as! String)
                if(isUser && revieweeUserType as! String == UserType.user.rawValue) {
                    reviews.append(newReview)
                } else if (!isUser && revieweeUserType as! String == UserType.worker.rawValue) {
                    reviews.append(newReview)
                }
            }
            completion(reviews)
        }
        completion([])
    }
    
    public func createReview(review: Review, revieweeId: String, orderId: String) {
        let reviewDict = try! DictionaryEncoder.encode(review) as NSDictionary
        db.child(Constants.reviews).child(revieweeId).childByAutoId().setValue(reviewDict)
        if review.revieweeUserType == UserType.user.rawValue {
            db.child(Constants.userOrders).child(revieweeId).child(orderId).updateChildValues(["isWorkerCommented": true])
        }
        else if review.revieweeUserType == UserType.worker.rawValue {
            db.child(Constants.userOrders).child(user!.uid).child(orderId).updateChildValues(["isUserCommented": true])
        }
        
    }
}

// MARK: Order Mgmt
extension FirebaseDBService {
    public func createNewOrder(value:NSDictionary, id: String) {
        let ref = db.child(Constants.userOrders)
        ref.child(user!.uid).child(id).setValue(value)
    }
    
    public func applyOrder(id: String, userId:String, workerId:String) {
        let ref = db.child(Constants.userOrders)
        ref.child(userId).child(id)
            .updateChildValues(["workerId": workerId, "status": UserOrderType.applied.rawValue])
    }
    
    public func retrievePendingOrders(completion: @escaping ([UserOrder]) -> Void) {
        let ref = db.child(Constants.userOrders)
        var openingOrder = [UserOrder]()
        ref.observeSingleEvent(of: .value, with: { snapshots in
            if let snapshots = snapshots.value {
                for snapshot in snapshots as! Dictionary<String, Any>  {
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
            }else{
                completion([])
            }
        })
    }
    
    public func retrieveWorkOrders(completion: @escaping ([UserOrder]) -> Void) {
        let ref = db.child(Constants.userOrders)
        let workerId = Auth.auth().currentUser!.uid
        var openingOrder = [UserOrder]()
        ref.observeSingleEvent(of: .value, with: { snapshots in
            if let snapshots = snapshots.value {
                for snapshot in snapshots as! Dictionary<String, Any>  {
                    let allOrders = snapshot.value as! Dictionary<String, Any>
                    for order in allOrders {
                        let orderDict = order.value as! Dictionary<String, Any>
                        if orderDict["workerId"] as! String == workerId {
                            let address = self.convertDictToAddress(item: orderDict["address"] as! Dictionary<String, Any>)
                            let orderObj = self.convertDictToOrder(dict: orderDict, address: address)
                            openingOrder.append(orderObj)
                        }
                    }
                }
                let sortedOrders = openingOrder.sorted(by: {($0.date, $0.id)>($1.date, $1.id)})
                completion(sortedOrders)
            }else{
                completion([])
            }
        })
    }
    
    public func retrieveUserOrders(completion: @escaping ([UserOrder]) -> Void) {
        let ref = db.child(Constants.userOrders).child(user!.uid)
        var orders = [UserOrder]()
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard snapshot.exists() else { return }
            for order in snapshot.value as! Dictionary<String, Any>  {
                let orderDict = order.value as! Dictionary<String, Any>
                let address = self.convertDictToAddress(item: orderDict["address"] as! Dictionary<String, Any>)
                let order = self.convertDictToOrder(dict: orderDict, address: address)
                orders.append(order)
            }
            let sortedOrders = orders.sorted(by: {($0.date, $0.id)>($1.date, $1.id)})
            completion(sortedOrders)
        })
        completion([])
    }
    
    public func updateOrderStatus(orderId: String, value: [String: Any], isCancellOrder: Bool = false) {
        let ref = db.child(Constants.userOrders).child(user!.uid)
        ref.child(orderId)
            .updateChildValues(value)
        if isCancellOrder {
            ref.child(orderId).getData(completion: {err, data in
                guard err == nil else { return }
                let orderDict = data.value as! Dictionary<String, Any>
                let address = self.convertDictToAddress(item: orderDict["address"] as! Dictionary<String, Any>)
                let order = self.convertDictToOrder(dict: orderDict, address: address)
                order.id = UUID().uuidString
                order.status = UserOrderType.pending.rawValue
                order.workerId = ""
                let newOrderDict = try! DictionaryEncoder.encode(order)
                ref.child(order.id).setValue(newOrderDict)
            })
        }
    }
    
    public func retrieveOrderHistory(completion: @escaping ([History]) -> Void) {
        let ref = db.child(Constants.userOrders).child(user!.uid)
        var histories = [History]()
        ref.observeSingleEvent(of: .value, with: { snapshots in
            guard snapshots.exists() else { return }
            for snapshot in snapshots.value as! Dictionary<String, Any>  {
                let order = snapshot.value as! Dictionary<String, Any>
                if order["status"] as! String == UserOrderType.cancelled.rawValue
                    || order["status"] as! String == UserOrderType.completed.rawValue {
                    let address = self.convertDictToAddress(item: order["address"] as! Dictionary<String, Any>)
                    let orderObj = self.convertDictToOrder(dict: order, address: address)
                    let history = History(address: address.street, date: orderObj.date, status: orderObj.status)
                    histories.append(history)
                }
            }
            let sortedHistories = histories.sorted(by: {($0.date, $0.address)>($1.date, $1.address)})
            completion(sortedHistories)
        })
    }
    
    
    private func convertDictToOrder(dict: Dictionary<String, Any>, address: Address) -> UserOrder {
        let date = dict["date"] as? String ?? ""
        let duration = dict["duration"] as? Int ?? 0
        let message = dict["message"] as? String ?? ""
        let pet = dict["pet"] as? String ?? ""
        let selectedItems = dict["selectedItems"] as? [String] ?? []
        let status = dict["status"] as? String ?? ""
        let time = dict["time"] as? String ?? ""
        let tips = dict["tips"] as? Double ?? 0.0
        let totalCost = dict["totalCost"] as? Double ?? 0.0
        let id = dict["id"] as? String ?? ""
        let userId = dict["userId"] as? String ?? ""
        let workerId = dict["workerId"] as? String ?? ""
        let isUserCommented = dict["isUserCommented"] as? Bool ?? false
        let isWorkerCommented = dict["isWorkerCommented"] as? Bool ?? false
        let userOrder = UserOrder(date: date, time: time, duration: duration, address: address, pet: pet, message: message, selectedItems: selectedItems, tips: tips, totalCost: totalCost, userId: userId, id: id)
        userOrder.status = status
        userOrder.workerId = workerId
        userOrder.isUserCommented = isUserCommented
        userOrder.isWorkerCommented = isWorkerCommented
        return userOrder
    }
    
}

// MARK: Image Mgmt
extension FirebaseDBService {
    public func saveImage(image: UIImage, completion: @escaping(URL?) -> Void) {
        
        let fileName = NSUUID().uuidString
        let databaseRef = db.child("users").child(user!.uid)
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
        ref.child(user!.uid).setValue(["id": user!.uid, "email": user!.email, "type": value])
    }
    
    public func retrieveUser(completion: @escaping(User?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.child("users").child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    public func retrieveUserByEmail(email: String, completion: @escaping(User?) -> Void) {
        var users = [User]()
        db.child("users").observeSingleEvent(of: .value, with: {snapshot in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                for key in dict.keys {
                    if let item = dict[key] as? [String : AnyObject] {
                        let user = User(uid: key, dictionary: item)
                        users.append(user)
                    }
                }
                let targetUser = users.first(where: {$0.email == email})
                if(targetUser != nil) {
                    completion(targetUser)
                } else {
                    completion(nil)
                }
            }
        })
    }
    public func retrieveUserById(id: String, completion: @escaping(User?) -> Void) {
        db.child("users").child(id).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return completion(nil) }
            let user = User(uid: id, dictionary: dictionary)
            completion(user)
        }
    }
}

// MARK: Address Mgmt

extension FirebaseDBService {
    
    public func saveAddress(value:NSDictionary) -> DatabaseReference {
        let ref = db.child(Constants.userAddress)
        let child = ref.child(user!.uid).childByAutoId()
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
        ref.child(user!.uid).observeSingleEvent(of: .value, with: { snapshot in
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
