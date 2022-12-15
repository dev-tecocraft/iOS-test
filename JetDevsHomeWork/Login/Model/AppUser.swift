//
//  AppUser.swift
//
//  Created by Sanam on 13/12/22
//  Copyright (c) . All rights reserved.
//

import Foundation

struct AppUser: Codable {
    
    var errorMessage: String?
    var loginData: LoginData?
    var result: Int?
    
    enum CodingKeys: String, CodingKey {
        case errorMessage = "error_message"
        case loginData = "data"
        case result
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorMessage = try container.decodeIfPresent(String.self, forKey: .errorMessage)
        loginData = try container.decodeIfPresent(LoginData.self, forKey: .loginData)
        result = try container.decodeIfPresent(Int.self, forKey: .result)
    }
    
    init() {
        
    }
    
}
