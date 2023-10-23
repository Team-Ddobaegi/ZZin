//
//  DetailRegistrationCell.swift
//  ZZin
//
//  Created by Jack Lee on 2023/10/20.
//

import UIKit

class DetailRegistrationCell: UITableViewCell {
    static let reuseIdentifer = "cell"
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setUI() {
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func setTitle(text: String) {
        label.text = text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
