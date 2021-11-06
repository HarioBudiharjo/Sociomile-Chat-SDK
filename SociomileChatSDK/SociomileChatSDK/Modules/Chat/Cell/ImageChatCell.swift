//
//  ImageChatCell.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 21/10/21.
//

import UIKit
import Kingfisher

protocol ImageChatDelegate {
    func openWebView(url: URL?)
}

class ImageChatCell: UITableViewCell {

    @IBOutlet weak var contentImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    var delegate: ImageChatDelegate?
    var data: Chat!
    
    func setView(data: Chat) {
        self.data = data
        dateLabel.text = data.date
        if let url = data.imageUrl {
            contentImage.kf.setImage(with: url)
        }
        messageView.roundCorners(corners: [.bottomRight, .bottomLeft, .topLeft], radius: 20.0)
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.openAction))
        self.contentImage.addGestureRecognizer(gesture)
    }
    
    @objc func openAction(sender : UITapGestureRecognizer) {
        self.delegate?.openWebView(url: data.imageUrl)
    }
}
