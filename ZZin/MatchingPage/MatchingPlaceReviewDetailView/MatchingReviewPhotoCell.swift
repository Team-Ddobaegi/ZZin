//
//  MatchingContentsCell.swift
//  ZZin
//
//  Created by t2023-m0045 on 10/20/23.
//

import UIKit
import SnapKit


//MARK: - 매칭 업체 리뷰(포토)가 들어가는 셀 :: TableView Cell

class MatchingReviewPhotoCell: UITableViewCell {
    
    // MARK: - Life Cycles
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Settings
    
    private func setView(){
        backgroundColor = .white
        
        configureUI()
    }
    
    static func cellHeight() -> CGFloat {
            return 290
    }
    
    // MARK: - Properties
    
    static let identifier = "MatchingContentsCell"
    
    
    // 또배기 리뷰 사진이 들어갈 메세지 뷰
    private let photoMessageView = UIView().then {
        $0.backgroundColor = ColorGuide.lightGray
        $0.layer.cornerRadius = 25
    }
    
    private let photoMessageView2 = UIImageView().then {
        $0.image = UIImage(named: "photoMessage.png")
        $0.contentMode = .scaleAspectFill
    }
    
    
    // 사용자 리뷰 사진
   let photoImageView = UIImageView().then {
        $0.backgroundColor = .black
        $0.image = UIImage(named: "ogudangdang")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    
    //MARK: - configure UI
    
    private func configureUI(){
        addSubViews()
        setConstraints()
    }
    
    private func addSubViews(){
        contentView.addSubview(photoMessageView2)
        contentView.addSubview(photoMessageView)
        photoMessageView.addSubview(photoImageView)
    }
    
    private func setConstraints(){
        photoMessageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
            $0.height.equalTo(270)
        }
        
        photoMessageView2.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.top.equalTo(photoMessageView.snp.bottom).inset(30)
            $0.left.equalTo(photoMessageView.snp.left)
            
        }
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(30)
        }
    }
}
