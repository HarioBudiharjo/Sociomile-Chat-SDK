//
//  FormDao.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 26/10/21.
//

import Foundation

// MARK: - LoginDAO
struct LoginDAO: Codable {
    let status: Bool?
    let data: DataLoginDao?
    
    // MARK: - DataClass
    struct DataLoginDao: Codable {
        let token, tiketID: String?
        let queue: Int?

        enum CodingKeys: String, CodingKey {
            case token
            case tiketID = "tiket_id"
            case queue
        }
    }
}

// MARK: - FormDAO
struct FormDAO: Codable {
    let status: Bool?
}

// MARK: - AgentDAO
struct AgentDAO: Codable {
    let data: DataAgentDao?
    
    // MARK: - DataClass
    struct DataAgentDao: Codable {
        let status: Bool?
    }
}
