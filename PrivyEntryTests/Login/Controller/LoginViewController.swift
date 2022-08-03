//
//  LoginViewController.swift
//  PrivyEntryTests
//
//  Created by Michael Louis on 02/08/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    
    var service = Service()
    var loginUrl = "http://pretest-qa.dcidev.id/api/v1/oauth/sign_in"
    var progressHUD : ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressHUD()
    }
    
    func setupProgressHUD(){
        progressHUD = getHUD(text: "Logging in...")
        self.view.addSubview(progressHUD)
        self.progressHUD.hide()
    }
    
    @IBAction func loginButtonDidTapped(_ sender: Any) {
        self.progressHUD.show()
        if let phone = phoneTextField.text,
           let pass = passwordTextField.text {
            service.login(url: loginUrl, username: phone, password: pass) { accessToken, err in
                if err == nil {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
                        if let resp = accessToken {
                            vc.auth = resp
                            self.navigationController?.pushViewController(vc, animated: true)
                            self.progressHUD.hide()
                        } else {
                            self.showAlert(text: "login failed")
                        }
                    }
                }
                self.progressHUD.hide()
            }
        } else {
            showAlert(text: "empty parameters")
        }
    }
}
