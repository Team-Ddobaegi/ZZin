//
//  EditProfileViewController.swift
//  ZZin
//
//  Created by t2023-m0055 on 2023/10/17.
//

import UIKit

class EditProfileViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setNav()
    }
    
    func setNav() {
        self.title = "내 프로필 편집"
    }
}
