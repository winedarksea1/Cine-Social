//
//  FeedVC.swift
//  Cine-Social
//
//  Created by Andrew McGovern on 1/9/18.
//  Copyright © 2018 Andrew McGovern. All rights reserved.
//

import UIKit
import FirebaseAuth

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Actions
    
    @IBAction func signOutTapped(_ sender: Any) {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: ID removed from keychain \(removeSuccessful)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "SignInVC", sender: nil)
    }

}
