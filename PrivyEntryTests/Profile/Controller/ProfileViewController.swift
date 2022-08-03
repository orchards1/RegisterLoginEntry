//
//  ProfileViewController.swift
//  PrivyEntryTests
//
//  Created by Michael Louis on 02/08/22.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, ImagePickerDelegate {
    func didSelect(picker: ImagePicker, image: UIImage?) {
        if picker == coverImagePicker {
            coverImageView.image = image
        } else {
            avatarImageView.image = image
        }
    }
    
    
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var profileLabel: UILabel!
    @IBOutlet var careerLabel: UILabel!
    @IBOutlet var educationLabel: UILabel!
    var profile: Profile?
    var auth: String?
    var name: String?
    var hometown: String?
    var genderInt: Int?
    var service = Service()
    var profUrl = "http://pretest-qa.dcidev.id/api/v1/profile/me"
    var coverImagePicker: ImagePicker!
    var avatarImagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coverImagePicker = ImagePicker(presentationController: self, delegate: self)
        self.avatarImagePicker = ImagePicker(presentationController: self, delegate: self)
        self.title = "Profile"
        getData()
    }
    
    func getData() {
        if let auth = auth {
            service.getProfile(url: profUrl, auth: auth) { profile, Error in
                    if let userPictureUrl = profile?.data?.user?.userPicture?.picture?.url {
                        let data = try? Data(contentsOf: URL(string: userPictureUrl) ?? URL(string: "")!)
                        DispatchQueue.main.async {
                        self.avatarImageView.image = UIImage(data: data!)
                        }
                    }
                    if let coverPictureUrl = profile?.data?.user?.coverPicture?.url {
                        let data = try? Data(contentsOf: URL(string: coverPictureUrl) ?? URL(string: "")!)
                        DispatchQueue.main.async {
                            self.coverImageView.image = UIImage(data: data!)
                        }
                    }
                    DispatchQueue.main.async {
                        let prof = profile?.data?.user
                        self.name = prof?.name ?? "no name yet"
                        let gender = prof?.gender ?? "no gender yet"
                        if gender == "male" {
                            self.genderInt = 0
                        } else {
                            self.genderInt = 1
                        }
                        self.hometown = prof?.hometown ?? "no hometown yet"
                        let companyName = prof?.career?.companyName ?? "no company info"
                        let schoolName = prof?.education?.schoolName ?? "no school name"
                        self.profileLabel.text = self.name! + " - " + gender + " - " + self.hometown!
                        self.careerLabel.text = companyName
                        self.educationLabel.text = schoolName
                    }
                }
            }
    }
    
    @IBAction func editProfileDidTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Update", message: "Choose what to update", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "name", style: .default, handler: { action in
            self.showUpdateField(title: "name", nama: self.name!, gender: self.genderInt!, hometown: self.hometown!)
        }))
        alertController.addAction(UIAlertAction(title: "gender", style: .default, handler: { action in
            self.showUpdateField(title: "gender", nama: self.name!, gender: self.genderInt!, hometown: self.hometown!)
        }))
        alertController.addAction(UIAlertAction(title: "hometown", style: .default, handler: { action in
            self.showUpdateField(title: "hometown", nama: self.name!, gender: self.genderInt!, hometown: self.hometown!)
        }))
        alertController.addAction(UIAlertAction(title: "companyName", style: .default, handler: { action in
            self.showUpdateCareer()
        }))
        alertController.addAction(UIAlertAction(title: "schoolName", style: .default, handler: { action in
            self.showUpdateEducation()
        }))
        alertController.addAction(UIAlertAction(title: "cover image", style: .default, handler: { action in
            self.showUpdateCoverImage()
        }))
        alertController.addAction(UIAlertAction(title: "avatar image", style: .default, handler: { action in
            self.showUpdateAvatarImage()
        }))
        self.present(alertController, animated: true)
    }
    
    func showUpdateCareer() {
        let alertController = UIAlertController(title: "Update Company name", message: "edit below textfield", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter new value"
        }
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textfield = alertController.textFields![0] as UITextField
            self.service.editCareer(auth: self.auth!, companyName: textfield.text!, completion: { err in
                self.getData()
                if (err != nil) {
                    print(err)
                }
            })
        }))
        self.present(alertController,animated: true)
    }
    func showUpdateEducation() {
        let alertController = UIAlertController(title: "Update school name", message: "edit below textfield", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Enter new value"
        }
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textfield = alertController.textFields![0] as UITextField
            self.service.editEducation(auth: self.auth!, schoolName: textfield.text!, completion: { err in
                self.getData()
                if (err != nil) {
                    print(err)
                }
            })
        }))
        self.present(alertController,animated: true)
    }
    func showUpdateField(title: String,nama: String, gender: Int, hometown: String) {
        let alertController = UIAlertController(title: "Update \(title)", message: "edit below textfield", preferredStyle: .alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            if title == "gender" {
                textField.placeholder = "0 for male/ 1 for female"
            } else {
                textField.placeholder = "Enter new value"
            }
        }
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { alert -> Void in
            let textfield = alertController.textFields![0] as UITextField
            if title == "name" {
                self.service.editProfile(auth: self.auth!, name: textfield.text!, gender: gender, hometown: hometown) { err in
                    self.getData()
                    if (err != nil) {
                        print(err)
                    }
                }
            } else if title == "hometown"{
                self.service.editProfile(auth: self.auth!, name: self.name!, gender: gender,hometown: textfield.text!) { err in
                    self.getData()
                    if (err != nil) {
                        print(err)
                    }
                }
            } else {
                textfield.placeholder = "0 for male / 1 for female"
                self.service.editProfile(auth: self.auth!, name: self.name!, gender: Int(textfield.text!)!,hometown: self.hometown!) { err in
                    self.getData()
                    if (err != nil) {
                        print(err)
                    }
                }
            }
        }))
        self.present(alertController,animated: true)
    }
    func showUpdateCoverImage() {
        let alertController = UIAlertController(title: "Update cover image", message: "edit below textfield", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Upload Image", style: .default, handler: { alert -> Void in
            self.coverImagePicker.present(from: self.view)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { alert -> Void in
        }))
        self.present(alertController,animated: true)
    }
    func showUpdateAvatarImage() {
        let alertController = UIAlertController(title: "Update avatar image", message: "edit below textfield", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Upload Image", style: .default, handler: { alert -> Void in
            self.avatarImagePicker.present(from: self.view)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { alert -> Void in
        }))
        self.present(alertController,animated: true)
    }
}
