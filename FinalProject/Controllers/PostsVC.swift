//
//  ViewController.swift
//  FinalProject
//
//  Created by Amani Atiah on 09/05/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class PostsVC: UIViewController {

    
    // MARK: OUTLET
    @IBOutlet weak var postTableView: UITableView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var HiLabel: UILabel!
    
    @IBOutlet weak var tagContainerView: UIView!
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var newPostButtonContainerView: ShadowView!
    var posts: [Post] = []
    var tag: String?
    

    var page = 0
    var total = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(newPostAdded), name: NSNotification.Name("NewPostAdded"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentPostEdited), name: NSNotification.Name(rawValue: "currentPostEdited"), object: nil)
        
        
        

        
        tagContainerView.layer.cornerRadius = 20
        //check if user is logged in or it's only a guest
        if let user = UserManager.loggedInUser {
            HiLabel.text = "Hi, \(user.firstName)"
       
        } else {
            HiLabel.isHidden = true
            newPostButtonContainerView.isHidden = true
        }
        
        postTableView.dataSource = self
        postTableView.delegate = self
        
        
        // check if thereis a tag
        if let myTag = tag {
            tagNameLabel.text = myTag
        } else {
            tagContainerView.isHidden = true
            closeButton.isHidden = true

        }
        
        
        
        // subscriping to the notification
        
        NotificationCenter.default.addObserver(self, selector: #selector(userProfileTapped), name: NSNotification.Name("userStackViewTapped"), object: nil)
        
    
      getPosts()
        
    }
    
 
    

    func getPosts() {
        loaderView.startAnimating()
        PostAPI.getAllPost(page: page, tag: tag) { postResponse, total in
            self.total = total
            self.posts.append(contentsOf: postResponse)
            self.postTableView.reloadData()
            self.loaderView.stopAnimating()
        }
    }

    @objc func newPostAdded() {
        self.posts = []
        self.page = 0
        getPosts()
    }
    
    @objc func currentPostEdited() {
        self.posts = []
        getPosts()
               
    }
    // MARK: ACTIONS
    @objc func userProfileTapped(notification: Notification){
        
        if let cell = notification.userInfo?["cell"] as? UITableViewCell{
            if let indexPath = postTableView.indexPath(for: cell) {
                let post = posts[indexPath.row]
                
                let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                
                vc.user = post.owner
                present(vc, animated: true, completion: nil)
            }
   
        }
   
        
    }
    
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "logoutSegue" {
            UserManager.loggedInUser = nil
        }
    }
}

extension PostsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = posts[indexPath.row]
        cell.postTextLabel.text = post.text
        
        // the logic of filling the image from the url
        let imageStringUrl = post.image
        cell.postImageView.setImageFromStringUrl(stringUrl: imageStringUrl)
        
        // the logic of filling the user's image from the url
        let userImageStringUrl = post.owner.picture
        cell.userImageView.makeCirclerImage()
        
        if let image = userImageStringUrl {
            cell.userImageView.setImageFromStringUrl(stringUrl: image)
            
        }
        // filling the user data
        cell.usernameLabel.text = post.owner.firstName + " " + post.owner.lastName
        cell.likesNumberLabel.text = String(post.likes)
            

        
        cell.tags = post.tags ?? []
        cell.tagsCollectionView.reloadData()
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 602
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPost = posts[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PostDetailsVC") as!  PostDetailsVC
        vc.post = selectedPost
        present(vc, animated: true, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == posts.count - 1 && posts.count < total{
            page = page + 1
            getPosts()
            
        }
    }
    
    
    
}

