//
//  Service.swift
//  PrivyEntryTests
//
//  Created by Michael Louis on 01/08/22.
//

import Foundation
import UIKit

class Service : NSObject {
    
    func editCareer(auth: String, companyName: String, completion: @escaping (Error?)-> Void) {
        let url = URL(string: "http://pretest-qa.dcidev.id/api/v1/profile/career")!
        let parameters = ["position" : "officer", "company_name" : companyName, "starting_from":"2014-01-01T23:28:56.782Z","ending_in":"2014-01-01T23:28:56.782Z"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(error)
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                completion(nil)
            }
        })
        task.resume()
    }
    
    func editEducation(auth: String, schoolName: String, completion: @escaping (Error?)-> Void) {
        let url = URL(string: "http://pretest-qa.dcidev.id/api/v1/profile/education")!
        let parameters = ["school_name": schoolName,"graduation_time":"2014-01-01T23:28:56.782Z"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(error)
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                completion(nil)
            }
        })
        task.resume()
    }
    
    func editProfile(auth: String, name: String, gender: Int,hometown:String, completion: @escaping (Error?)-> Void) {
        let url = URL(string: "http://pretest-qa.dcidev.id/api/v1/profile")!
        let parameters = ["name": name, "hometown": hometown, "gender": String(gender), "bio": "bio", "birthday" : "2014-01-01T23:28:56.782Z"]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(error)
        }
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                completion(nil)
            }
        })
        task.resume()
    }
    
    func getProfile(url: String, auth: String, completion: @escaping (Profile?, Error?) -> Void){
        let url = URL(string: url)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                let profile = try? JSONDecoder().decode(Profile.self, from: data)
                completion(profile, nil)
            }
        })
        task.resume()
    }
    
    func resendOTP(url: String, phone: String, completion: @escaping (Error?) -> Void){
        let parameters = ["phone": phone]
        let url = URL(string: url)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(error)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil)
                return
            }

            guard let data = data else {
                completion(NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                completion(nil)
            }
        })
        task.resume()
    }
    
    func verifOTP(url: String, id: String, OTP: String, completion: @escaping (String?, Error?) -> Void) {
        let parameters = ["user_id": id, "otp_code": OTP]
        let url = URL(string: url)!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                let OTP = try? JSONDecoder().decode(OTPToken.self, from: data)
                completion(OTP?.data.user.accessToken, nil)
            }
        })
        task.resume()
    }
    func postRequest(url: String, username: String, password: String, country: String, completion: @escaping (String?, Error?) -> Void) {
        let parameters = ["phone": username, "password": password, "device_type": "0", "country": country, "latlong": "", "device_token": "1231"]
        let url = URL(string: url)!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                let register = try? JSONDecoder().decode(Register.self, from: data)
                completion(register?.data.user.id, nil)
            }
        })
        task.resume()
    }
    
    func login(url: String, username: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        let parameters = ["phone": username, "password": password, "device_type": "0", "latlong": "", "device_token": "1231"]
        let url = URL(string: url)!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }

            do {
                let user = try? JSONDecoder().decode(OTPToken.self, from: data)
                completion(user?.data.user.accessToken, nil)
            }
        })
        task.resume()
    }
}
