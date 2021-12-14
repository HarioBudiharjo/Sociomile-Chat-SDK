//
//  ChatEntity.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 01/11/21.
//

import UIKit

struct Chat {
    let id: Int
    let name: String
    let message: String
    let imageUrl: URL?
    let documentUrl: URL?
    let date: String
    let type: TypeMessage
}

enum TypeMessage: String {
    case document = "document"
    case image = "image"
    case message = "message"
}

enum FileType: String {
    case document = "document"
    case image = "image"
}
