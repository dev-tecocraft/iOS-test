//
//  AccountViewController.swift
//  JetDevsHomeWork
//
//  Created by Gary.yao on 2021/10/29.
//

import UIKit
import Kingfisher

class AccountViewController: UIViewController {

	@IBOutlet weak var nonLoginView: UIView!
	@IBOutlet weak var loginView: UIView!
	@IBOutlet weak var daysLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var headImageView: UIImageView!
    
    let accountViewModel = AccountViewModel()
    
	override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
		nonLoginView.isHidden = false
		loginView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let user = UserDefaults.getUserDataFromDefault() {
            nonLoginView.isHidden = true
            loginView.isHidden = false
            nameLabel.text = user.userName
            daysLabel.text = accountViewModel.getDays(created: user.createdAt ?? "2022-12-07T04:30:49.822Z")
            guard let strUrl = user.userProfileUrl, let url = URL(string: strUrl) else {
                return
            }
            headImageView.kf.setImage(with: url, placeholder: UIImage(named: "Avatar"))
            headImageView.contentMode = .scaleToFill
        }
    }
	
	@IBAction func loginButtonTap(_ sender: UIButton) {
        
        let nextVc = LoginViewController(nibName: "LoginViewController", bundle: nil)
        nextVc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(nextVc, animated: true
        )
	}
}
