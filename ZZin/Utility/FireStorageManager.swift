//
//  FireStorageManager.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/27.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseStorageUI
import FirebaseFirestore
import Firebase
import SDWebImage

enum Useage {
    case place, review, profile, town
}

class FireStorageManager {
    func downloadImgFromStorage(useage: Useage, id: String, imageView: UIImageView) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        switch useage {
        case .place:
            
            let docRef = db.collection("places").document(id)
            docRef.getDocument {(document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? nil
                    let imageName = dataDescription!["placeImg"] as! [String]
                    let reference = storage.reference().child("places/\(imageName[1])")
                    
                    // Placeholder image
                    let placeholderImage = UIImage(named: "add_photo.png")
                    
                    // Load the image using SDWebImage
                    imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
                }
            }
        case .review:
            
            let docRef = db.collection("reviews").document(id)
            docRef.getDocument {(document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? nil
                    let imageName = dataDescription!["reviewImg"] as! String
                    let reference = storage.reference().child("reviews/\(imageName)")
                    
                    // Placeholder image
                    let placeholderImage = UIImage(named: "add_photo.png")
                    
                    // Load the image using SDWebImage
                    imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
                }
            }
        case .profile:
            let docRef = db.collection("users").document(id)
            docRef.getDocument {(document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data() ?? nil
                    let imageName = dataDescription!["profileImg"] as! String
                    let reference = storage.reference().child("profiles/\(imageName)")
                    
                    // Placeholder image
                    let placeholderImage = UIImage(named: "add_photo.png")
                    
                    // Load the image using SDWebImage
                    imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
                }
            }
        default: print("default")
        }
    
    }
}
