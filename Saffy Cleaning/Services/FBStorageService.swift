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
    
    func saveImages(images: [UIImage], imageRef: String) -> [String] {
        var imagePath = [String]()
        let ref = storage.child(imageRef)
        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        guard images != [] else { return [] }
        for image in images {
            let uuid = UUID().uuidString
            guard let imageData = image.pngData() else {
                print("Failed to conver image to .png")
                return []
            }
            ref.child("\(uuid).png").putData(imageData, metadata: metadata , completion: {_, err in
                guard err == nil else {
                    print("Failed to upload data")
                    return
                }
            })
            imagePath.append(uuid)
        }
        return imagePath
    }
    
//    func retrieveImages(filesNames: [String], imageRef: String) -> [UIImage] {
//        var images = [UIImage]()
//        let ref = storage.child(imageRef)
//
//        // handle empty image list
//        guard filesNames != [] else {
//            print("no images")
//            return []
//        }
//
//        for filesName in filesNames {
//            ref.child("\(filesName).png").getData(maxSize: 20*1024*1025, completion: { data, error in
//                guard error == nil else{
//                    print("Failed to get data")
//                    return
//                }
//                let image = UIImage(data: data!)
//                images.append(image!)
//            })
//        }
//    }

}
