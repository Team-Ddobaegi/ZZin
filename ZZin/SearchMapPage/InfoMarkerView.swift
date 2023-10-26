//
//  InfoMarkerView.swift
//  ZZin
//
//  Created by t2023-m0061 on 10/26/23.
//

import UIKit

class InfoMarkerView: UIView {
    
    //    let imgView = UIImageView(frame: .init(x: 0, y: 0, width: 24, height: 24)).then {
    //        $0.clipsToBounds = true
    //        $0.layer.cornerRadius = 12
    //    }
    //
    //    let informationLabel = UILabel(frame: .init(x: 24 + 8, y: 24 / 2 - 16 / 2, width: 16, height: 16)).then {
    //        $0.font = .systemFont(ofSize: 16)
    //    }
    
    let informationLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .black
        $0.backgroundColor = .clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(){
        backgroundColor = .lightGray
        informationLabel.text = "ㄱㄴㄷㄹ"
        informationLabel.backgroundColor = .red

    }
    
    private func attribute() {
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func layout() {
        addSubview(informationLabel)
        
        informationLabel.snp.makeConstraints{
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct InfoMarkerView_Preview: PreviewProvider {
    struct PreviewWrapper: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            return InfoMarkerView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        }

        func updateUIView(_ view: UIView, context: Context) {
            // update view if needed
        }
    }

    static var previews: some View {
        PreviewWrapper().previewLayout(.sizeThatFits).padding()
    }
}

#endif

