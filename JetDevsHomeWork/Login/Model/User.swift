//
//  User.swift
//
//  Created by Sanam on 13/12/22
//  Copyright (c) . All rights reserved.
//

import Foundation

struct User: Codable {
    
    var userId: Int?
    var userName: String?
    var userProfileUrl: String?
    var createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case userName = "user_name"
        case userProfileUrl = "user_profile_url"
        case createdAt = "created_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decodeIfPresent(Int.self, forKey: .userId)
        userName = try container.decodeIfPresent(String.self, forKey: .userName)
        userProfileUrl = try container.decodeIfPresent(String.self, forKey: .userProfileUrl)
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
    }
    
}
