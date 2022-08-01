//
//  Service.swift
//  PrivyEntryTests
//
//  Created by Michael Louis on 01/08/22.
//

import Foundation

class Service : NSObject {
    
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
}
