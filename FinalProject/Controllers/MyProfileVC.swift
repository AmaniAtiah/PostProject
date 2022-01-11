//
//  MyProfileVC.swift
//  FinalProject
//
//  Created by Amani Atiah on 19/05/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class MyProfileVC: UIViewController {

    // MARK: OUTLET
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    
   
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var imageUrlTextField: UITextField!
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    

        setupUI()

    }
    
    
    @IBAction func exitButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
  
    
    func setupUI(){
        userImageView.makeCirclerImage()
        if let user = UserManager.loggedInUser {
            if let image = user.picture {
                userImageView.setImageFromStringUrl(stringUrl: image)
            }
            nameLabel.text = user.firstName + " " + user.lastName
            
            firstNameTextField.text = user.firstName
            phoneTextField.text = user.phone
            imageUrlTextField.text = user.picture
            
            
         }
    }
    
    
    
    // MARK: ACTIONS
    @IBAction func submitButtonClicked(_ sender: Any) {


        guard let loggedInUser = UserManager.loggedInUser else {return}

            
            loaderView.startAnimating()

            
            UserAPI.updateUserInfo(userId: loggedInUser.id, firstName: firstNameTextField.text!, phone: phoneTextField.text!, imageUrl: imageUrlTextField.text!) { user, message in
            
                self.loaderView.stopAnimating()
                
                NotificationCenter.default.post(name: NSNotification.Name("UpdateProfile"), object: nil, userInfo: ["updateUser": user])
                
                if let responseUser = user {
                    if let image = user?.picture {
                        self.userImageView.setImageFromStringUrl(stringUrl: image)
                        
                    }
                    self.nameLabel.text = responseUser.firstName + " " + responseUser.lastName
                    

                }
                
            }
            
        }

}


