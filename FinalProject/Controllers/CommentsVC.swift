//
//  CommentsVC.swift
//  FinalProject
//
//  Created by Amani Atiah on 21/05/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class CommentsVC: UIViewController {
    var post: Post!
    var comments: [Comment] = []

    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    @IBOutlet weak var addCommenetStackView: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        
        if UserManager.loggedInUser == nil{
            addCommenetStackView.isHidden = true
        }
        
        getPostComment()

    }
    
    func getPostComment() {
        loaderView.startAnimating()
        PostAPI.getPostComments(id: post.id) { commentResponse in
            self.comments = commentResponse
            self.commentTableView.reloadData()
            self.loaderView.stopAnimating()
        }
        
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        let message = commentTextField.text!
        if let user = UserManager.loggedInUser {
            loaderView.startAnimating()
            PostAPI.addNewCommentToPost(postId: post.id, userId: user.id, message: message)
            {
                self.getPostComment()
                self.commentTextField.text = ""
                
            }
        }
    }
    
}

extension CommentsVC: UITableViewDelegate, UITableViewDataSource {
func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell", for: indexPath) as! AddCommentCell
    let currentComment = comments[indexPath.row]
    cell.commentLabel.text = currentComment.message
    cell.usernameLabel.text = currentComment.owner.firstName + " " + currentComment.owner.lastName
    
    if let userImage = currentComment.owner.picture {
        cell.userImageView.setImageFromStringUrl(stringUrl: userImage)
    }
    
    cell.userImageView.makeCirclerImage()
    return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let comment = comments[indexPath.row]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        vc.user = comment.owner
        present(vc, animated: true, completion: nil)
    }

}
