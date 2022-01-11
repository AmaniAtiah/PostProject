//
//  NewPostVC.swift
//  FinalProject
//
//  Created by Amani Atiah on 19/05/1443 AH.
//

import UIKit
import NVActivityIndicatorView
import TextFieldEffects

class NewPostVC: UIViewController {
    
    var tags: [String] = []
    var items: [String]? = []
    var isCreationPost = true
    var editedPost: Post?

    // MARK: OUTLET
    @IBOutlet weak var headerPostLabel: UILabel!
    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var postTextTextField: UITextField!
    @IBOutlet weak var postImageTextField: UITextField!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var tagLoaderView: NVActivityIndicatorView!
    @IBOutlet weak var addButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagTableView.tableFooterView = UIView()
        
        tagTableView.dataSource = self
        tagTableView.delegate = self
        
    
        tagLoaderView.startAnimating()
        PostAPI.getAllTags { tags in
            self.tagLoaderView.stopAnimating()
            self.tags = tags
            self.tagTableView.reloadData()
            
       
        }
        
        if !isCreationPost {
            addButton.setTitle("Update", for: .normal)
            headerPostLabel.text = "Update Post"
            if let post = editedPost {
                postTextTextField.text = post.text
                postImageTextField.text = post.image
           

            }
        }
        


    }
    

    
    
    // MARK: ACTIONS
    @IBAction func addPostButtonClicked(_ sender: Any) {
       
            if let user = UserManager.loggedInUser {
                addButton.setTitle("", for: .normal)
                loaderView.startAnimating()
                if let selectedRows = tagTableView.indexPathsForSelectedRows {
                    if var item = items {
                       // item.removeAll()
                        for indexPath in selectedRows {
                            item.append(tags[indexPath.row])
                            
                        }
                      
                        item = item.map { $0.trimmingCharacters(in: .whitespaces) }
                        print(item)
                        if isCreationPost {
                 
                            PostAPI.addNewPost(text: postTextTextField.text!, image: postImageTextField.text!, userId: user.id, tag: item) {
                                self.loaderView.stopAnimating()
                                self.addButton.setTitle("add", for: .normal)
                                NotificationCenter.default.post(name: NSNotification.Name("NewPostAdded"), object: nil, userInfo: nil)
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                        } else {
                            if let post = editedPost {
                                PostAPI.updatePostInfo(text: postTextTextField.text!, image: postImageTextField.text!, postId: post.id , tag: item ) { responsePost in
                                    self.loaderView.stopAnimating()
                                
                                    self.addButton.setTitle("update", for: .normal)
                                    NotificationCenter.default.post(name: NSNotification.Name("currentPostEdited"), object: nil, userInfo: ["editedPost": responsePost])
                                    
                                    self.dismiss(animated: true, completion: nil)



                                
                            }

                            }
                        
                        }
                        
                    }
                    
                }
                
            }
            
        
    }
    
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
   
    }
    

   
}



extension NewPostVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tagTableView.dequeueReusableCell(withIdentifier: "AddTagCell", for: indexPath) as! AddTagCell
        let currentTag = tags[indexPath.row]
        cell.tagNameLabel.text = currentTag
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tagTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tagTableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}
    
    

