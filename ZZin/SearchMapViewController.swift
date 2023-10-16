//
//  SearchMapViewController.swift
//  ZZin
//
//  Created by t2023-m0061 on 2023/10/16.
//

import UIKit
import NMapsMap
import SwiftUI

class SearchMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let naverMapView = NMFNaverMapView(frame: view.frame)
        view.addSubview(naverMapView)
    }
    


}

//@available(iOS 13.0, *)
//struct SearchMapViewControllerPreview: PreviewProvider {
//    static var previews: some View {
//        SearchMapViewControllerWrapper()
//            .edgesIgnoringSafeArea(.all)
//    }
//}
//
//@available(iOS 13.0, *)
//struct SearchMapViewControllerWrapper: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> SearchMapViewController {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier: "SearchMapViewController") as! SearchMapViewController
//        return viewController
//    }
//    
//    func updateUIViewController(_ uiViewController: SearchMapViewController, context: Context) {
//    }
//}
