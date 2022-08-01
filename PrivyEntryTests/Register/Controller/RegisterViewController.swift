//
//  RegisterViewController.swift
//  PrivyEntryTests
//
//  Created by Michael Louis on 01/08/22.
//

import UIKit

class RegisterViewController: UIViewController, URLSessionDelegate {
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var countryTextField: UITextField!
    
    var regUrl = "http://pretest-qa.dcidev.id/api/v1/register"
    var service = Service()
    let progressHUD = ProgressHUD(text: "Register..")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func registerDidTapped(_ sender: Any) {
        self.view.addSubview(progressHUD)
        let phone = phoneTextField.text
        if validateRegister() {
            showAlert()
        } else {
            service.postRequest(url: regUrl, username: phone ?? "", password: passwordTextField.text ?? "", country: countryTextField.text ?? "") { resp, err in
                if err == nil {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "OTPVerification", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "OTPVerification") as! OTPViewController
                        if let resp = resp {
                            vc.id = resp
                            vc.no = self.phoneTextField.text!
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            self.showAlert()
                        }
                        self.progressHUD.hide()
                    }
                }
            }
        }
    }
    
    func validateRegister() -> Bool {
        return phoneTextField.text == "" || passwordTextField.text == "" || countryTextField.text == "" ? true : false  
    }
}

extension RegisterViewController {
    func showAlert() {
        let alert = UIAlertController(title: "empty parameter", message: "please input some parameter", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
}
