//
//  ProfileVC.swift
//  FinalProject
//
//  Created by Amani Atiah on 12/05/1443 AH.
//

import UIKit


class ProfileVC: UIViewController {
    
    var user: User!

    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.makeCirclerImage()
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        UserAPI.getUserData(id: user.id) { userResponse in
            self.user = userResponse
            self.setUpUI()
        }

    }
    

    func setUpUI(){
        nameLabel.text = user.firstName + " " + user.lastName
  
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        genderLabel.text = user.gender
        
        if let location = user.location{
            countryLabel.text = location.country! + " - " + location.city!
        }
        
        if let image = user.picture {
            profileImageView.setImageFromStringUrl(stringUrl: image)

        }
 
    }


}
