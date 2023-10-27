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
    
    // 해당 useage의 경로 및 컬렉션 이름 반환
    var pathAndCollection: (path: String, collection: String) {
        switch self {
        case .place:
            return ("places", "places")
        case .review:
            return ("reviews", "reviews")
        case .profile:
            return ("profiles", "users")
        case .town:
            return ("", "") // 이건 필요에 따라 적절하게 수정해주세요.
        }
    }
}

class FireStorageManager {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    func downloadImgFromStorage(useage: Useage, id: String, imageView: UIImageView) {
        // Placeholder image
        let placeholderImage = UIImage(named: "add_photo.png")
        
        let docRef = db.collection(useage.pathAndCollection.collection).document(id)
        docRef.getDocument { (document, error) in
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            guard let document = document, document.exists, let dataDescription = document.data() else {
                print("Document does not exist or data is nil.")
                return
            }
            
            let keyName: String
            switch useage {
            case .place:
                keyName = "placeImg"
            case .review:
                keyName = "reviewImg"
            case .profile:
                keyName = "profileImg"
            default:
                keyName = "" // 이건 필요에 따라 적절하게 수정해주세요.
            }
            
            guard let imageName = dataDescription[keyName] else {
                print("Error: Image name not found.")
                return
            }
            
            var path: String
            if let imageNameArray = imageName as? [String], !imageNameArray.isEmpty {
                path = "\(useage.pathAndCollection.path)/\(imageNameArray[0])"
            } else if let imageNameString = imageName as? String {
                path = "\(useage.pathAndCollection.path)/\(imageNameString)"
            } else {
                print("Error: Invalid image name format.")
                return
            }
            
            let reference = self.storage.reference().child(path)
            // Load the image using SDWebImage
            imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        }
    }
}
