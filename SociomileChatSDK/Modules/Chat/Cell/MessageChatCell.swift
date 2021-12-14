//
//  MessageChatCell.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 21/10/21.
//

import UIKit

class MessageChatCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    func setView(data: Chat) {
        self.timeLabel.text = data.date
        self.messageLabel.text = data.message
        messageView.roundCorners(corners: [.bottomRight, .bottomLeft, .topLeft], radius: 20.0)
    }
}
