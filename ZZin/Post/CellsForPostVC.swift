//
//  PostTableViewCell.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/25.
//

import UIKit
import SnapKit
import Then

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    
    var titleLabel = UILabel().then{
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .light)
    }
    
    var placeholderLabel = UILabel().then{
        $0.textColor = .systemGroupedBackground
        $0.font = .systemFont(ofSize: 13, weight: .regular)
    }
    
    var textField = UITextField().then {
        $0.borderStyle = .none  // 테두리 스타일
        $0.layer.borderWidth = 0
        $0.layer.cornerRadius = 12
        $0.layer.backgroundColor = UIColor.quaternarySystemFill.cgColor
        $0.autocorrectionType = .no // 자동 수정 활성화 여부
        $0.spellCheckingType = .no  // 맞춤법 검사 활성화 여부
        $0.autocapitalizationType = .none  // 자동 대문자 활성화 여부
        $0.clearButtonMode = .always // 입력내용 한번에 지우는 x버튼(오른쪽)
        $0.clearsOnBeginEditing = false
        $0.addLeftPadding()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setTextFields()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setTextFields() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.top.left.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(textField)
        textField.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.size.equalTo(CGSize(width: UIScreen.main.bounds.width - 32, height: 50))
        }
    }
}

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}


class PostPlaceInfoCell: UITableViewCell {
    
    static let identifier = "PostPlaceInfoCell"
    
    var titleLabel = UILabel().then{
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .light)
    }
    
    var infoLabel = UILabel().then{
        $0.textColor = .systemGroupedBackground
        $0.font = .systemFont(ofSize: 13, weight: .regular)
    }
    
    var underline = UIView().then {
        $0.backgroundColor = .black
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(underline)
        underline.snp.makeConstraints{
            $0.left.equalTo(titleLabel.snp.right).offset(16)
            $0.right.equalToSuperview().inset(16)
            $0.centerY.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(1)
        }
        
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints{
            $0.centerX.equalTo(underline)
            $0.bottom.equalTo(underline.snp.top).offset(-5)
        }
        
        
    }
}


//func textFieldDidBeginEditing(_ textField: UITextField) {
//        placeholderLabel.snp.updateConstraints {
//            $0.centerY.equalTo(textField).offset(-10)
//        }
//        UIView.animate(withDuration: 1) {
//            self.placeholderLabel.font = .systemFont(ofSize: 10)
//            self.placeholderLabel.superview?.layoutIfNeeded()
//            // Textfield의 슈퍼뷰를 업데이트
//            // self.view.layoutIfNeeded()
//            // viewcontroller의 뷰를 업데이트 (상황에 맞게 사용)
//        }
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        placeholderLabel.snp.updateConstraints {
//            $0.center.equalTo(textField)
//        }
//        UIView.animate(withDuration: 0.5) {
//            self.placeholderLabel.font = .systemFont(ofSize: 16)
//            self.placeholderLabel.superview?.layoutIfNeeded()
//    //      self.view.layoutIfNeeded()
//        }
//    }
//


class ImgSelectionTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    static let identifier = "ImgSelectionTableViewCell"
    
    var imgCount = 1
    var imgArray: [String] = []
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    var titleLabel = UILabel().then{
        $0.textColor = .label
        $0.text = "후기 사진"
        $0.font = .systemFont(ofSize: 15, weight: .light)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImgSelectionCollectionViewCell.self, forCellWithReuseIdentifier: ImgSelectionCollectionViewCell.identifier)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.top.left.equalToSuperview().inset(16)
        }
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {imgArray.count + 1}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImgSelectionCollectionViewCell.identifier, for: indexPath) as! ImgSelectionCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let interItemSpacing: CGFloat = 10
//    let width = (collectionView.bounds.width - interItemSpacing * 3) / 5
//    let height = width
        return CGSize(width: 100, height: 100)
    }
}

class ImgSelectionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImgSelectionCollectionViewCell"
    
    var addImgButton = UIButton().then {
        $0.setImage(UIImage(named: "add_photo"), for: .normal)
        $0.layer.cornerRadius = 10
        $0.layer.backgroundColor = UIColor.systemGray6.cgColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(addImgButton)
        addImgButton.snp.makeConstraints{
            $0.top.left.equalToSuperview()
            $0.size.equalTo(CGSize(width: 100, height: 100))
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

class SelectKeywordsTableViewCell: UITableViewCell {
    
    static let identifier = "SelectKeywordsTableViewCell"
    
    var firstKeywordButton = UIButton().customButton(title: "키워드")
    var secondKeywordButton = UIButton().customButton(title: "키워드")
    var menuKeywordButton = UIButton().customButton(title: "키워드")
    
    let titleLabel = UILabel().then{
        $0.textColor = .label
        $0.text = "키워드 선정"
        $0.font = .systemFont(ofSize: 15, weight: .light)
    }
    
    let infoLabel = UILabel().then{
        $0.textColor = .label
        $0.text = "3가지를 가진 맛집"
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    let searchNotiLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "각 항목을 탭하면 다른 키워드를 선택할 수 있어요!"
        $0.textColor = .systemGray
    }
    
    let searchTipLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.text = "tip"
        $0.textColor = ColorGuide.main
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.top.left.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(infoLabel)
        infoLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
        
        contentView.addSubview(searchNotiLabel)
        searchNotiLabel.snp.makeConstraints{
            $0.top.equalTo(infoLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview().offset(4)
        }
        
        contentView.addSubview(searchTipLabel)
        searchTipLabel.snp.makeConstraints{
            $0.centerY.equalTo(searchNotiLabel)
            $0.right.equalTo(searchNotiLabel.snp.left).offset(-4)
        }
        
        contentView.addSubview(firstKeywordButton)
        firstKeywordButton.snp.makeConstraints{
            $0.top.equalTo(searchNotiLabel.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(secondKeywordButton)
        secondKeywordButton.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(firstKeywordButton)
        }
        
        contentView.addSubview(menuKeywordButton)
        menuKeywordButton.snp.makeConstraints{
            $0.top.equalTo(searchNotiLabel.snp.bottom).offset(16)
            $0.right.equalToSuperview().inset(16)
        }
    }
}


class PostPlaceContentCell: UITableViewCell {
    
    static let identifier = "PostPlaceContentCell"
    
    var titleLabel = UILabel().then{
        $0.textColor = .label
        $0.text = "방문 후기"
        $0.font = .systemFont(ofSize: 15, weight: .light)
    }
    
    let textView = UITextView().then{
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.layer.borderWidth = 0
        $0.layer.cornerRadius = 12
        $0.layer.backgroundColor = UIColor.quaternarySystemFill.cgColor
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.autocapitalizationType = .none
        $0.text = "당신의 찐 맛집을 소개해주세요."
        $0.textColor = .lightGray
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    let submitButton = UIButton().then{
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = ColorGuide.main
        $0.layer.cornerRadius = 12
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
        textView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.top.left.equalToSuperview().inset(16)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(150)
        }
        
        contentView.addSubview(submitButton)
        submitButton.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(60)
        }
        

    }
    
}

extension PostPlaceContentCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "당신의 찐 맛집을 소개해주세요." {
            textView.text = nil
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "당신의 찐 맛집을 소개해주세요."
            textView.textColor = .lightGray
        }
    }
}
