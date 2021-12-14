//
//  ReceivedChatCell.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 01/11/21.
//

import UIKit

class ReceivedChatCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    func setView(data: Chat) {
        messageLabel.text = data.message
        dateLabel.text = data.date
        messageView.roundCorners(corners: [.bottomRight, .bottomLeft, .topRight], radius: 20.0)
    }
    
}
