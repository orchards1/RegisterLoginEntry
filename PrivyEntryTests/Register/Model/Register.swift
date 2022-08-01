//
//  Register.swift
//  PrivyEntryTests
//
//  Created by Michael Louis on 01/08/22.
//

import Foundation

// MARK: - Register
struct Register: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let user: User
}

// MARK: - User
struct User: Codable {
    let id, phone, userStatus, userType: String
    let sugarID, country: String
    let latlong: JSONNull?
    let userDevice: UserDevice

    enum CodingKeys: String, CodingKey {
        case id, phone
        case userStatus = "user_status"
        case userType = "user_type"
        case sugarID = "sugar_id"
        case country, latlong
        case userDevice = "user_device"
    }
}

// MARK: - UserDevice
struct UserDevice: Codable {
    let deviceToken, deviceType, deviceStatus: String

    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case deviceStatus = "device_status"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
