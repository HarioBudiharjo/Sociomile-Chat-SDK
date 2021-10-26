//
//  FormEntity.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 26/10/21.
//

import Foundation

struct Form: Encodable {
    let id: String
    let name: String
    let email: String
    let phone: String
    let message: String
}
