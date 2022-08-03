//
//  Profile.swift
//  PrivyEntryTests
//
//  Created by Michael Louis on 02/08/22.
//

import Foundation

// MARK: - Profile
struct Profile: Codable {
    let data: DataClass2?
}

// MARK: - DataClass
struct DataClass2: Codable {
    let user: UserProfile?
}

// MARK: - User
struct UserProfile: Codable {
    let id, name: String?
    let level, age: Int?
    let birthday, gender, zodiac, hometown: String?
    let bio, latlong: String?
    let education: Education?
    let career: Career?
    let userPictures: [UserPicture]?
    let userPicture: UserPicture?
    let coverPicture: Picture?

    enum CodingKeys: String, CodingKey {
        case id, name, level, age, birthday, gender, zodiac, hometown, bio, latlong, education, career
        case userPictures = "user_pictures"
        case userPicture = "user_picture"
        case coverPicture = "cover_picture"
    }
}

// MARK: - Career
struct Career: Codable {
    let companyName, startingFrom, endingIn: String?

    enum CodingKeys: String, CodingKey {
        case companyName = "company_name"
        case startingFrom = "starting_from"
        case endingIn = "ending_in"
    }
}

// MARK: - Picture
struct Picture: Codable {
    let url: String?
}

// MARK: - Education
struct Education: Codable {
    let schoolName, graduationTime: String?

    enum CodingKeys: String, CodingKey {
        case schoolName = "school_name"
        case graduationTime = "graduation_time"
    }
}

// MARK: - UserPicture
struct UserPicture: Codable {
    let id: String?
    let picture: Picture?
}
