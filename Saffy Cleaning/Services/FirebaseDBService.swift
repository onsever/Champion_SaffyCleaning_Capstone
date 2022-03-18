//
//  FirebaseDBService.swift
//  Saffy Cleaning
//
//  Created by Mark Chan on 16/3/2022.
//


import FirebaseDatabase
import FirebaseAuth



class FirebaseDBService {
    static let service = FirebaseDBService()
    
    private let db = Database.database().reference()
    
    private let user = Auth.auth().currentUser!
    

    
    func observe(endpoint: String, event: DataEventType = .value, completion: @escaping (DataSnapshot) -> Void) {
        let ref = db.child(endpoint)
        ref.observe(event, with: completion)
    }
    
    func syncUserType(value: String) {
        let ref = db.child(Constants.userTypes)
        ref.child(user.uid).setValue(["id": user.uid, "email": user.email, "type": value])
    }
    
    func saveAddress(value:NSDictionary) {
        let ref = db.child(Constants.userAddress)
        ref.child(user.uid).childByAutoId().setValue(value)
    }
    
    func createNewOrder(value:NSDictionary) {
        let ref = db.child(Constants.userOrders)
        ref.child(user.uid).childByAutoId().setValue(value)
    }
    
    func retrieveOrder(completion: @escaping([UserOrder]?)-> Void) {
    }
    
    func retrieveAddress(completion: @escaping([Address]?) -> Void) {
        var addresses = [Address]()
        addresses = []
        let ref = db.child(Constants.userAddress)
        ref.child(user.uid).observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? Dictionary<String, Any> {
                for key in dict.keys {
                    if let item = dict[key] as? Dictionary<String, Any> {
                        let street = item["street"] ?? ""
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
                        let newAddress = Address(
                            name: name as! String,
                            room: room as! String,
                            flat: flat as! String,
                            street: street as! String,
                            building: building as! String,
                            district: district as! String,
                            contactPerson: contactPerson as! String,
                            contactNumber: contactNumber as! String,
                            type: type as! String,
                            sizes: sizes as! String,
                            longitude: longitude as! Double,
                            latitude: latitude as! Double)
                        addresses.append(newAddress)
                    }
                }
                completion(addresses)
            }else {
                completion([])
            }
        })
    }
}
