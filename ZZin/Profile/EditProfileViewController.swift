//
//  EditProfileViewController.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/17.
//

import UIKit
import SnapKit
import Then
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import PhotosUI

class EditProfileViewController: UIViewController, UITextFieldDelegate, PHPickerViewControllerDelegate {
    
    var storageManager = FireStorageManager()
    var storeManager = FireStoreManager.shared
    var profileImgData: Data?
    var userName: String?
    var profileDescription: String?
    let currentUid = MainViewController().uid!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        self.tabBarController?.tabBar.isHidden = true
        userNameTextField.delegate = self
        descriptionTextField.delegate = self
        
        hideKeyboardWhenTappedAround()
        setNav()
        setupUI()
        setButtonAction()
        
        DispatchQueue.main.async { [self] in
            storageManager.bindProfileImgOnStorage(uid: currentUid, profileImgView: editProfileButton.profileImageView, userNameLabel: nil, descriptionLabel: nil, userNameTextField: userNameTextField, descriptionTextField: descriptionTextField)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setNav() {
        self.title = "내 프로필 편집"
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            dismiss(animated: true, completion: nil)

            let itemProvider = results.first?.itemProvider
            if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            self?.editProfileButton.profileImageView.image = image
                            self?.profileImgData = image.jpegData(compressionQuality: 0.8)
                            
                            print(self?.profileImgData as Any)
                        }
                    }
                }
            }
        }
    
    // 프로필 편집
    // 1. 사진 수정
    // 2. 닉네임 수정
    // 3. 지역 설정 변경
    // 4. 한 문장 설명
    
    
    var editProfileButton = profileButton()
    
    var usernameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.text = "닉네임 변경"
        $0.textColor = .label
    }
    
    var descriptionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.text = "한 줄 소개"
        $0.textColor = .label
    }
    
    var userNameTextField = UITextField().then{
        $0.textColor = .label
        $0.borderStyle = .none
        $0.placeholder = "변경할 닉네임 입력"
        $0.layer.cornerRadius = 12
        $0.layer.backgroundColor = UIColor.quaternarySystemFill.cgColor
        $0.autocorrectionType = .no // 자동 수정 활성화 여부
        $0.spellCheckingType = .no  // 맞춤법 검사 활성화 여부
        $0.autocapitalizationType = .none  // 자동 대문자 활성화 여부
        $0.clearButtonMode = .never // 입력내용 한번에 지우는 x버튼(오른쪽)
        $0.addLeftPadding()
    }
    
    var descriptionTextField = UITextField().then{
        $0.textColor = .label
        $0.borderStyle = .none
        $0.placeholder = "한 줄 소개 입력"
        $0.layer.cornerRadius = 12
        $0.layer.backgroundColor = UIColor.quaternarySystemFill.cgColor
        $0.autocorrectionType = .no // 자동 수정 활성화 여부
        $0.spellCheckingType = .no  // 맞춤법 검사 활성화 여부
        $0.autocapitalizationType = .none  // 자동 대문자 활성화 여부
        $0.clearButtonMode = .never // 입력내용 한번에 지우는 x버튼(오른쪽)
        $0.addLeftPadding()
    }
    
    var submitButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main
        $0.layer.cornerRadius = 15
        $0.isUserInteractionEnabled = true
    }
    
    private func setupUI() {
        view.addSubview(editProfileButton)
        editProfileButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(150)
            $0.size.equalTo(CGSize(width: 85, height: 85))
        }
        
        view.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(18)
            $0.top.equalTo(editProfileButton.snp.bottom).offset(30)
        }
        
        view.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints{
            $0.top.equalTo(usernameLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(45)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints{
            $0.top.equalTo(userNameTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().inset(20)
        }
        
        view.addSubview(descriptionTextField)
        descriptionTextField.snp.makeConstraints{
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(45)
        }
        
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(30)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
    }
    
    func setButtonAction(){
        editProfileButton.addTarget(self, action: #selector(didTappedProfileButton), for: .touchUpInside)
        
        submitButton.addTarget(self, action: #selector(didTappedSubmitButton), for: .touchUpInside)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case userNameTextField:
            userName = userNameTextField.text
        case descriptionTextField:
            profileDescription = descriptionTextField.text
        default: return
        }
    }
    
    @objc func didTappedProfileButton() {
        print("프로필 클릭")
        
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 1
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    @objc func didTappedSubmitButton() {
        print("제출 클릭")
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateUserInfo(uid: String, profileImgData: Data?) {
        
        let userName = self.userNameTextField.text
        let description = self.descriptionTextField.text
        
        storageManager.uploadProfileImg(profileImg: profileImgData, uid: currentUid)
        let userRef = storeManager.db.collection("users").document(uid)
        var imgPath: String?
        
        if profileImgData == nil {
            imgPath = "profiles/default_profile.png"
        } else {
            imgPath = "profiles/\(uid).jpeg"
        }
        
        userRef.updateData(["userName": userName!,
                            "description": description ?? "",
                            "profileImg": imgPath!]) { error in
            if let error = error {
                print("유저 데이터 업로드 중 에러가 발생했습니다 : \(error)")
            } else {
                print("유저 데이터 업로드 성공 : \(uid)")
            }
        }
    }

}

extension EditProfileViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


class profileButton: UIButton {
    
    var profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 85 / 2
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFill
//        $0.layer.borderWidth = 1
//        $0.layer.borderColor = ColorGuide.main.cgColor
        $0.backgroundColor = .systemGray4
    }
    
    let cameraBadgeImageView = UIImageView().then{
        $0.layer.cornerRadius = 24/2
        $0.layer.masksToBounds = true
        $0.backgroundColor = .systemGroupedBackground
        $0.tintColor = .label
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "camera.fill")?.withAlignmentRectInsets(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        addSubview(cameraBadgeImageView)
        cameraBadgeImageView.snp.makeConstraints{
            $0.bottom.right.equalToSuperview()
            $0.size.equalTo(CGSize(width: 20, height: 20))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
