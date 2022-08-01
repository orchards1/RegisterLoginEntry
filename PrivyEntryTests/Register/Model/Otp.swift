//
//  Otp.swift
//  PrivyEntryTests
//
//  Created by Michael Louis on 01/08/22.
//

import Foundation

// MARK: - OTPToken
struct OTPToken: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let user: User
}

// MARK: - User
struct User: Codable {
    let accessToken, tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
    }
}
