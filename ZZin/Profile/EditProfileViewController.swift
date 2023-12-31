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
import Lottie

class EditProfileViewController: UIViewController, UITextFieldDelegate, PHPickerViewControllerDelegate {
    
    var storageManager = FireStorageManager()
    var storeManager = FireStoreManager.shared
    var profileImgData: Data? = nil
    var userName: String? = nil
    var profileDescription: String? = nil
    let currentUid = MainViewController().uid!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
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
    
    
    var editProfileButton = profileButton()
    var underView = UIView().then{
        $0.backgroundColor = .systemBackground
    }
    
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
    
    var lottieView: LottieAnimationView = LottieAnimationView(name: "loadingLottie").then {
        $0.loopMode = .loop
        $0.isHidden = true
    }
    
    

    
    
    private func setupUI() {
        view.addSubview(underView)
        underView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        underView.addSubview(editProfileButton)
        editProfileButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(150)
            $0.size.equalTo(CGSize(width: 85, height: 85))
        }
        
        underView.addSubview(usernameLabel)
        usernameLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(18)
            $0.top.equalTo(editProfileButton.snp.bottom).offset(30)
        }
        
        underView.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints{
            $0.top.equalTo(usernameLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(45)
        }
        
        underView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints{
            $0.top.equalTo(userNameTextField.snp.bottom).offset(30)
            $0.left.equalToSuperview().inset(20)
        }
        
        underView.addSubview(descriptionTextField)
        descriptionTextField.snp.makeConstraints{
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(45)
        }
        
        underView.addSubview(submitButton)
        submitButton.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(30)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
        
        view.addSubview(lottieView)
        lottieView.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.size.equalTo(CGSize(width: 200, height: 200))
        }
    }
    
    func setButtonAction(){
        editProfileButton.addTarget(self, action: #selector(didTappedProfileButton), for: .touchUpInside)
        
        submitButton.addTarget(self, action: #selector(didTappedSubmitButton), for: .touchUpInside)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        switch textField {
        case userNameTextField:
            userName = userNameTextField.text
        case descriptionTextField:
            profileDescription = descriptionTextField.text
        default: return
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
        
        let popup = UIAlertController(title: "프로필 정보 변경", message: "정말로 프로필을 변경하시겠습니까?", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let confirmSave = UIAlertAction(title: "변경", style: .default) { [self] _ in
            // 클릭 시 처리할 내용
            updateUserInfo(uid: currentUid, profileImgData: profileImgData)
        }
        popup.addAction(cancel)
        popup.addAction(confirmSave)
        self.present(popup, animated: true)

    }
    
    
    func updateUserInfo(uid: String, profileImgData: Data?) {
        lottieView.play()
        lottieView.isHidden = false
        underView.backgroundColor = .darkGray
        underView.layer.opacity = 0.3
        
        let userName = self.userNameTextField.text
        let description = self.descriptionTextField.text
        
        storageManager.uploadProfileImg(profileImg: profileImgData, uid: currentUid)
        let userRef = storeManager.db.collection("users").document(uid)
        if profileImgData == nil {
            userRef.updateData(["userName": userName!,
                                "description": description ?? ""
                               ]) { error in
                if let error = error {
                    print("유저 데이터 업로드 중 에러가 발생했습니다 : \(error)")
                } else {
                    print("유저 데이터 업로드 성공 : \(uid)")
                }
            }
        } else {
            userRef.updateData(["userName": userName!,
                                "description": description ?? "",
                                "profileImg": "profiles/\(uid).jpeg"]) { error in
                if let error = error {
                    print("유저 데이터 업로드 중 에러가 발생했습니다 : \(error)")
                } else {
                    print("유저 데이터 업로드 성공 : \(uid)")
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { [self] in
            lottieView.isHidden = true
            underView.backgroundColor = .systemBackground
            underView.layer.opacity = 1.0
            self.navigationController?.popViewController(animated: true)
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

