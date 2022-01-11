//
//  PostDetailsVC.swift
//  FinalProject
//
//  Created by Amani Atiah on 10/05/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class PostDetailsVC: UIViewController {

    var post: Post!
    var comments: [Comment] = []
   
    // MARK: OUTLET
    
    
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var userStackView: UIStackView!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postImagView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var numberOfLikesLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var newCommentStackView: UIStackView!

    
    //  MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateButton.isHidden = true
        if UserManager.loggedInUser == nil {
            newCommentStackView.isHidden = true


        }

        
        exitButton.layer.cornerRadius = exitButton.frame.width / 2
        userNameLabel.text = post.owner.firstName + " " + post.owner.lastName
        
        setUpUI()

        
        if post.owner.id == UserManager.loggedInUser?.id {
            updateButton.isHidden = false

        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentPostEdited), name: NSNotification.Name(rawValue: "currentPostEdited"), object: nil)
        
    }
    @objc func currentPostEdited(notification: Notification) {
        if let post = notification.userInfo?["editedPost"] as? Post {
            self.post = post
            setUpUI()
        }
    }
     
    func setUpUI() {
        postTextLabel.text = post.text
        numberOfLikesLabel.text = String(post.likes)
        
        if let image = post.owner.picture {
            userImageView.setImageFromStringUrl(stringUrl: image)

        }
        postImagView.setImageFromStringUrl(stringUrl: post.image)
        userImageView.makeCirclerImage()
    }


    

    // MARK: ACTIONS
    
    @IBAction func commentButtonClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "CommentsVC") as!  CommentsVC
        vc.post = post
        present(vc, animated: true, completion: nil)
        
    }
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    @IBAction func edotButtonClicked(_ sender: Any) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: "NewPostVC") as? NewPostVC {
            
            
            viewController.isCreationPost = false
            viewController.editedPost = post
            
        present(viewController, animated: true, completion: nil)
     
        }
    }
    

      
   
    
            
}

    




