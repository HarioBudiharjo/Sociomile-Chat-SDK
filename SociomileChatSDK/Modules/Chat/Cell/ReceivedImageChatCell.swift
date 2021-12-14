//
//  ReceivedImageChatCell.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 05/11/21.
//

import UIKit
import Kingfisher

protocol ReceivedImageChatDelegate {
    func download(url: URL?)
    func open(url: URL?)
}

class ReceivedImageChatCell: UITableViewCell {
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var downloadImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var delegate: ReceivedImageChatDelegate?
    var data: Chat?
    
    func setView(data: Chat) {
        self.data = data
        if data.type == .document {
            previewImage.image = UIImage(named: "pdf", in: SociomileRouter.bundle(), compatibleWith: nil)
//            nameLabel.text = data.message
        } else {
            if let url = data.imageUrl {
                previewImage.kf.setImage(with: url)
            }
            nameLabel.text = ""
        }
        
        dateLabel.text = data.date
        
        let gestureDownload = UITapGestureRecognizer(target: self, action:  #selector(self.downloadAction))
        downloadImage.addGestureRecognizer(gestureDownload)
        
        let gesturePreview = UITapGestureRecognizer(target: self, action:  #selector(self.openAction))
        previewImage.addGestureRecognizer(gesturePreview)
    }
    
    @objc func openAction(sender : UITapGestureRecognizer) {
        guard let data = data else {
            return
        }
        if data.type == .document {
            self.delegate?.open(url: data.documentUrl)
        } else {
            self.delegate?.open(url: data.imageUrl)
        }
    }
    
    @objc func downloadAction(sender : UITapGestureRecognizer) {
        guard let data = data else {
            return
        }
        if data.type == .document {
            self.delegate?.download(url: data.documentUrl)
        } else {
            self.delegate?.download(url: data.imageUrl)
        }
    }
}
