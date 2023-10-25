//
//  RegionSearchResultTableViewCell.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/24.
//


import UIKit

class RegionSearchResultTableViewCell: UITableViewCell {
    static let identifier = "placeResultCell"

    let regionLabel = UILabel().then {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 18, weight: .semibold)
    }
    
    let descriptionLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = .init(white: 1.0, alpha: 0.1)
            print(regionLabel.text as Any)
            print(descriptionLabel.text as Any)
        } else {
            self.backgroundColor = .none
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLayout() {
        addSubview(regionLabel)
        regionLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(20)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints{
            $0.top.equalTo(regionLabel.snp.bottom).offset(8)
            $0.left.equalTo(regionLabel.snp.left)
        }
    }

}

