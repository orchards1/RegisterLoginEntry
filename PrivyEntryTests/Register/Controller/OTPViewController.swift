//
//  OTPViewController.swift
//  PrivyEntryTests
//
//  Created by Michael Louis on 01/08/22.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet var otp1: UITextField!
    @IBOutlet var otp2: UITextField!
    @IBOutlet var otp3: UITextField!
    @IBOutlet var otp4: UITextField!
    
    var id = "0"
    var no = ""
    var input = ""
    var otpUrl = "http://pretest-qa.dcidev.id/api/v1/register/otp/match"
    var resendOTPUrl = "http://pretest-qa.dcidev.id/api/v1/register/otp/request"
    
    var service = Service()
    var progressHUD : ProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(id)
        setupOTP()
    }
    func setupOTP() {
        otp1.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otp2.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otp3.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otp4.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        progressHUD = getHUD(text: "Verifying...")
        self.view.addSubview(progressHUD)
        self.progressHUD.hide()

    }
    @objc func textFieldDidChange(textField: UITextField){

        let text = textField.text
        if (text?.utf16.count)! >= 1{
            switch textField{
            case otp1:
                otp2.becomeFirstResponder()
            case otp2:
                otp3.becomeFirstResponder()
            case otp3:
                otp4.becomeFirstResponder()
            case otp4:
                otp4.resignFirstResponder()
            default:
                break
            }
        }else {}
    }

    @IBAction func verifikasiDidTapped(_ sender: Any) {
        self.progressHUD.show()
        input = otp1.text! + otp2.text! + otp3.text! + otp4.text!
        service.verifOTP(url: otpUrl, id: id, OTP: input) { accessToken, err in
            if err == nil {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Profile", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
                    if let resp = accessToken {
                        vc.auth = resp
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.showAlert(text: "register failed")
                    }
                    self.progressHUD.hide()
                }
            }

        }
    }

    @IBAction func resendOTPDidTapped(_ sender: Any) {
        self.progressHUD.show()
        service.resendOTP(url: resendOTPUrl, phone: no) { err in
            self.progressHUD.hide()
        }
    }
    
}
extension ViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
}
