//
//  UserPostsVC.swift
//  FinalProject
//
//  Created by Amani Atiah on 06/06/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class UserPostsVC: UIViewController {
    var posts: [Post] = []
    var tag: String?
    var selectedPost: Post!


    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userPostCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(newPostAdded), name: NSNotification.Name("NewPostAdded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentPostEdited), name: NSNotification.Name(rawValue: "currentPostEdited"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateProfile), name: NSNotification.Name(rawValue: "UpdateProfile"), object: nil)
        
        userPostCollectionView.dataSource = self
        userPostCollectionView.delegate = self
        
        
        

        getPosts()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI(){
        userImageView.makeCirclerImage()
        if let user = UserManager.loggedInUser {
            if let image = user.picture {
                userImageView.setImageFromStringUrl(stringUrl: image)
            }
            nameLabel.text = user.firstName + " " + user.lastName
        
         }
    }
    
    @objc func updateProfile(notification: Notification) {
        if let user = notification.userInfo?["updateUser"] as? User {
            UserManager.loggedInUser = user
            setupUI()

        }
        
    }

    func getPosts() {
        loaderView.startAnimating()
        if let user = UserManager.loggedInUser {
            PostAPI.getAllPostByUser(userId: user.id) { postResponse in 
            self.posts.append(contentsOf: postResponse)
            self.userPostCollectionView.reloadData()
            self.loaderView.stopAnimating()
        }
        }
    }
    
    @objc func newPostAdded() {
       addPostEndEdited()
    }
    
    @objc func currentPostEdited() {
        addPostEndEdited()
               
    }
    
    func addPostEndEdited() {
        self.posts = []
        getPosts()
    }

}

extension UserPostsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPostCell", for: indexPath) as! UserPostCell
        
        
        let post = posts[indexPath.row]
        
        let imageStringUrl = post.image
        cell.userPostImageView.setImageFromStringUrl(stringUrl: imageStringUrl)
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         selectedPost = posts[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostDetailsVC") as!  PostDetailsVC
        vc.post = selectedPost
        present(vc, animated: true, completion: nil)
    }
    
}
