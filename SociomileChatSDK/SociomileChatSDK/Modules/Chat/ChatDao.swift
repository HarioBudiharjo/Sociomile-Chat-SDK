//
//  ChatDao.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 02/11/21.
//

import Foundation

// MARK: - ChatDAO
struct ChatDAO: Codable {
    let status: Bool?
    let data: ChatDataClass?
}

// MARK: - DataClass
struct ChatDataClass: Codable {
    let name: Int?
    let type, dataExtension: String?

    enum CodingKeys: String, CodingKey {
        case name, type
        case dataExtension = "extension"
    }
}
