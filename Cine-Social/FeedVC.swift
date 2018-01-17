//
//  FeedVC.swift
//  Cine-Social
//
//  Created by Andrew McGovern on 1/9/18.
//  Copyright © 2018 Andrew McGovern. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageAdd: CircleView!
    
    var posts = [Post]()
    var imagePicker: UIImagePickerController!
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary<String, Any> {
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
    }
    
    // Protocol Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            if let image = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) {
                cell.configureCell(post: post, img: image)
                return cell
            } else {
                cell.configureCell(post: post)
                return cell
            }
        } else {
            return PostCell()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imageAdd.image = image
        } else {
            print("A valid image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    // Actions
    
    @IBAction func signOutTapped(_ sender: Any) {
        let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("JESS: ID removed from keychain \(removeSuccessful)")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "SignInVC", sender: nil)
    }

    @IBAction func addImageTapped(_ sender: Any) {
        present(imagePicker, animated: true, completion: {})
    }
}
