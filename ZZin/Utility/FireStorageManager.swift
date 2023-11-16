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
    let dataManager = FireStoreManager.shared
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    func downloadImgFromStorage(useage: Useage, id: String, imageView: UIImageView) {
        // Placeholder image
        let placeholderImage = UIImage(named: "review_placeholder.png")
        
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
            
            let reference = self.storageRef.child(path)
            // Load the image using SDWebImage
            imageView.sd_setImage(with: reference, placeholderImage: placeholderImage)
        }
    }
    
    func bindProfileImgOnStorage(uid: String, profileImgView: UIImageView, userNameLabel: UILabel?, descriptionLabel: UILabel?, userNameTextField: UITextField?, descriptionTextField: UITextField?) {
        
        print("============================== bindProfileImgOnStorage start")
        // Placeholder image
        let placeholderImage = UIImage(named: "profile")
        
        var path: String?
        var userName: String?
        var description: String?
        
        DispatchQueue.main.async { [self] in
            dataManager.fetchDataWithUid(uid: uid) { result in
                switch result {
                case .success(let user):
                    path = user.profileImg
                    userName = user.userName
                    description = user.description
                    
                    let profileRef = self.storageRef.child(path ?? "")
                    print("============================== bindProfileImgOnStorage start binding")
                    profileImgView.sd_setImage(with: profileRef, placeholderImage: placeholderImage)
                    print("============================== bindProfileImgOnStorage end")
                    
                    // UILabel이 있을 경우 binding
                    if userNameLabel != nil {
                        userNameLabel?.text = userName
                    } else {
                        userNameTextField?.text = userName
                    }
                    
                    guard description != nil else { return }
                    
                    if descriptionLabel != nil {
                        descriptionLabel?.text = description
                    } else {
                        descriptionTextField?.text = description
                    }
                case .failure(let error):
                    print("Error fetching place: \(error.localizedDescription)")
                    return
                }
            }
        }
    }
    
    func bindPlaceImgWithPath(path: String?, imageView: UIImageView) {
    
        let placeholderImage = UIImage(named: "review_placeholder.png")
        let ref = storageRef.child(path ?? "")
        imageView.sd_setImage(with: ref, placeholderImage: placeholderImage)
    }
    
    func getPidAndRidWithUid(uid: String, completion: @escaping ([String:[String]?]) -> Void?){
        print("############################START getPidAndRidWithUid")
        // user 정보에서 pid 배열 불러오기
        var pidArr: [String]?
        var ridArr: [String]?
        var dict: [String:[String]?] = [:]
        
        print(uid)
        dataManager.fetchDataWithUid(uid: uid) { result in
            switch result {
            case .success(let user):
                pidArr = user.pid
                ridArr = user.rid
                dict = ["pidArr": pidArr, "ridArr": ridArr]
                completion(dict)
            case .failure(let error):
                print("Error fetching place: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func bindViewOnStorageWithPid(pid: String?, placeImgView: UIImageView?, title: UILabel?, dotLabel: UILabel?, placeTownLabel: UILabel?, placeMenuLabel: UILabel?) {
        
        // placeholderImage
        let placeholderImage = UIImage(named: "review_placeholder.png")
        guard pid != nil || pid != "" else {return}
        dataManager.fetchDataWithPid(pid: pid!) { result in
            switch result {
            case .success(let place):
//                print("place : ", place)
                let path = place.placeImg[0]
                let ref = self.storageRef.child(path)
                placeImgView?.sd_setImage(with: ref, placeholderImage: placeholderImage)
                title?.text = place.placeName
                placeTownLabel?.text = place.town
                var kindOfFood = place.kindOfFood
                kindOfFood.remove(at: kindOfFood.startIndex)
                placeMenuLabel?.text = kindOfFood
            case .failure(let error):
                print("Error fetching place: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func bindViewOnStorageWithRid(rid: String?, reviewImgView: UIImageView?, title: UILabel?, companion: UILabel?, condition: UILabel?, town: UILabel?) {
      
        // placeholderImage
        let placeholderImage = UIImage(named: "review_placeholder.png")
        
        guard rid != nil || rid != "" else {return}
        dataManager.fetchDataWithRid(rid: rid!) { result in
            switch result {
            case .success(let review):
                let path = review.reviewImg // nil일 때 표시할 이미지 경로 추가
                let ref = self.storageRef.child(path?[0] as? String ?? "images/review_placeholder.gif")
                reviewImgView?.sd_setImage(with: ref, placeholderImage: placeholderImage)
                title?.text = review.title
                companion?.text = review.companion
                condition?.text = review.condition

            case .failure(let error):
                print("Error fetching place: \(error.localizedDescription)")
                return
            }
        }
    }
    
    func deleteFileWithPathArr(pathArr: [String]?) {
        if pathArr != nil {
            for path in pathArr! { // Delete the file
                let ref = storageRef.child(path)

                ref.delete { error in
                    if let error = error {
                        print("Uh-oh, an error occurred!")
                    } else {
                        print("File deleted successfully")
                    }
                }
            }
        }
    }
    
    func uploadProfileImg(profileImg: Data?, uid: String) {

        let storagePath = "profiles/\(uid).jpeg"
        let imagesRef = storageRef.child(storagePath)
        
        guard profileImg != nil else {return}
        imagesRef.putData(profileImg!, metadata: nil) { (metadata, error) in
        guard let _ = metadata else {
            print("Uh-oh, an error occurred for image \(storagePath)!")
                return
            }
        }
    }
}
