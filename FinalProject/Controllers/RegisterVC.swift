//
//  RegisterVC.swift
//  FinalProject
//
//  Created by Amani Atiah on 16/05/1443 AH.
//

import UIKit
import NVActivityIndicatorView

class RegisterVC: UIViewController {

    // MARK: OUTLET
    @IBOutlet weak var loaderView: NVActivityIndicatorView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var firstNameTextFiled: UITextField!
    @IBOutlet weak var lastNameTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    //MARK: LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: ACTIONS
    @IBAction func registerButtonClicked(_ sender: Any) {
        registerButton.setTitle("", for: .normal)
        loaderView.startAnimating()
        UserAPI.registerNewUser (firstName: firstNameTextFiled.text!, lastName: lastNameTextFiled.text!, email: emailTextField.text!) { user, errorMessage in
            self.loaderView.stopAnimating()
            if errorMessage != nil {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else {

                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController")
                self.present(vc!, animated: true, completion:nil)
               
            }
        }
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
