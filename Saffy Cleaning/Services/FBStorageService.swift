//
//  FBStorageService.swift
//  Saffy Cleaning
//
//  Created by Philip Chau on 2022-03-19.
//

import FirebaseStorage
import UIKit

class FBStorageService {
    static let service = FBStorageService()
    
    let storage = Storage.storage().reference()
    
    func saveImages(images: [UIImage], imageRef: String, completion: @escaping ([String]) -> Void) {
        var imagePath = [String]()
        let ref = storage.child(imageRef)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        guard images != [] else { return }
        
        for image in images {
            let uuid = UUID().uuidString
            let imageRef = ref.child("\(uuid).jpeg")

            guard let imageData = image.jpegData(compressionQuality: 0.5) else {
                print("Failed to convert image to .jpeg")
                return
            }
            
            imageRef.putData(imageData, metadata: metadata , completion: { _, err in
                guard err == nil else {
                    print("Failed to upload data")
                    print(err?.localizedDescription)
                    return
                }
                imageRef.downloadURL(completion: { url, err in
                    guard err == nil else {
                        print("Failed to get download url")
                        print(err?.localizedDescription)
                        return
                    }
                    let url = url!.absoluteString
                    print(url)
                    imagePath.append(url)
                    if imagePath.count == images.count {
                        completion(imagePath)
                    }
                })
            })
        }
    }

}
