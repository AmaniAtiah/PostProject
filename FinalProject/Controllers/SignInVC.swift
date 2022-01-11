//
//  SignInVC.swift
//  FinalProject
//
//  Created by Amani Atiah on 16/05/1443 AH.
//

import UIKit
import Spring
import NVActivityIndicatorView

class SignInVC: UIViewController {

    // MARK: OUTLET
    
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var signInLabel: SpringLabel!
    @IBOutlet weak var firstNameTextField: SpringTextField!
    
    @IBOutlet weak var lastNameTextField: SpringTextField!
    @IBOutlet weak var signInButton: SpringButton!
    @IBOutlet weak var registerButton: SpringButton!
    @IBOutlet weak var skipButton: SpringButton!
    //MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        self.firstNameTextField.text = "Amani"
        self.lastNameTextField.text = "Atiah"
        
        animateIn()

    }
    
    func animateIn() {
        firstNameTextField.animation = "zoomIn"
        firstNameTextField.delay = 0.5
        firstNameTextField.duration = 1
        firstNameTextField.animate()
        
        lastNameTextField.animation = "zoomIn"
        lastNameTextField.delay = 0.9
        lastNameTextField.duration = 1
        lastNameTextField.animate()
        
        signInButton.animation = "zoomIn"
        signInButton.delay = 1.4
        signInButton.duration = 1
        signInButton.animate()
        
        registerButton.animation = "fadeIn"
        registerButton.delay = 1.4
        registerButton.duration = 1
        registerButton.animate()
        
        skipButton.animation = "fadeInUp"
        skipButton.delay = 2
        skipButton.duration = 1.5
        skipButton.animate()
        
        signInLabel.animation = "fadeInRight"
        signInLabel.delay = 2.2
        signInLabel.duration = 1.7
        signInLabel.animate()
        
        

    }

    func animateOut(user: User?) {
        firstNameTextField.animation = "zoomIn"
        firstNameTextField.delay = 0.5
        firstNameTextField.duration = 1
        firstNameTextField.animateTo()
        
        lastNameTextField.animation = "zoomIn"
        lastNameTextField.delay = 0.9
        lastNameTextField.duration = 1
        lastNameTextField.animateTo()
        
        signInButton.animation = "zoomIn"
        signInButton.delay = 1.4
        signInButton.duration = 1
        signInButton.animateTo()
        
        registerButton.animation = "fadeIn"
        registerButton.delay = 1.4
        registerButton.duration = 1
        registerButton.animateTo()
        
        skipButton.animation = "fadeInUp"
        skipButton.delay = 2
        skipButton.duration = 1.5
        skipButton.animateTo()
        
        signInLabel.animation = "fadeInRight"
        signInLabel.delay = 2.2
        signInLabel.duration = 1.7
        signInLabel.animateNext {
            if let loggedInUser = user {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController")
                UserManager.loggedInUser = loggedInUser
                self.present(vc!, animated: true, completion: nil)
            }
      
        }
    }

    // MARK: ACTIONS
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        signInButton.setTitle("", for: .normal)
        loaderView.startAnimating()
        UserAPI.signInUser(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!) { user, errorMessage in
        
            self.loaderView.stopAnimating()
            if let message = errorMessage {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.animateOut(user: user)

              
            }
        }
    }
    
    
    
}
