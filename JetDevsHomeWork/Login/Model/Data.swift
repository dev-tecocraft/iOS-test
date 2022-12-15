//
//  LoginData.swift
//
//  Created by Sanam on 13/12/22
//  Copyright (c) . All rights reserved.
//

import Foundation

struct LoginData: Codable {
    
    var user: User?
    
    enum CodingKeys: String, CodingKey {
        case user
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decodeIfPresent(User.self, forKey: .user)
    }
    
}
