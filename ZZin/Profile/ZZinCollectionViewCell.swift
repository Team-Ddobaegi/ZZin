//
//  ZZinCollectionViewCell.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/17.
//

import UIKit

class ZZinCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var view: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        let zzinView = ZZinView()
        
        view.addSubview(zzinView)
        zzinView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}
