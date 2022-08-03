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
    var progressHUD : ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProgressHUD()
    }
    
    func setupProgressHUD(){
        progressHUD = getHUD(text: "Register...")
        self.view.addSubview(progressHUD)
        self.progressHUD.hide()
    }

    @IBAction func registerDidTapped(_ sender: Any) {
        self.progressHUD.show()
        if let phone = phoneTextField.text,
           let pass = passwordTextField.text,
           let country = countryTextField.text {
            service.postRequest(url: regUrl, username: phone, password: pass, country: country) { resp, err in
                if err == nil {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "OTPVerification", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "OTPVerification") as! OTPViewController
                        if let resp = resp {
                            vc.id = resp
                            vc.no = self.phoneTextField.text!
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            self.showAlert(text: "register failed")
                        }
                        self.progressHUD.hide()
                    }
                }
            }
        } else {
            showAlert(text: "empty parameters")
        }
    }
}

extension UIViewController {
    func showAlert(text: String) {
        let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert,animated: true)
    }
    func getHUD(text: String) -> ProgressHUD{
        let progressHUD = ProgressHUD(text: text)
        return progressHUD
    }
}
