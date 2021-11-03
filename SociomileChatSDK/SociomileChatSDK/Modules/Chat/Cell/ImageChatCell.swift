//
//  ImageChatCell.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 21/10/21.
//

import UIKit
import Kingfisher

class ImageChatCell: UITableViewCell {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    func setView(data: Chat) {
        dateLabel.text = data.date
        if let url = URL(string: data.message) {
            contentImage.kf.setImage(with: url)
        }
        messageView.roundCorners(corners: [.bottomRight, .bottomLeft, .topLeft], radius: 20.0)
    }
}
