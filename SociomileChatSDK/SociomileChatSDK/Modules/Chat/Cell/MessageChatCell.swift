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
    
    func setView(data: Chat) {
        self.timeLabel.text = data.date
        self.messageLabel.text = data.message
    }
}
