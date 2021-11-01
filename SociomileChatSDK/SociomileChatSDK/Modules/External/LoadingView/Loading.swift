//
//  Loading.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 01/11/21.
//

import UIKit

public class Loading: NSObject {
    public static let share = Loading()
    
    let contentView = LoadingView().loadNib() as! LoadingView
    
    public override init() {
        super.init()
    }
    
    public func show() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.keyWindow {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    self.contentView.alpha = 1
                    self.contentView.frame = window.frame
                    window.addSubview(self.contentView)
                    self.contentView.startAnimating()
                }, completion: nil)
            }
        }
    }
    
    public func hide() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.contentView.alpha = 0
                self.contentView.removeFromSuperview()
            }, completion: nil)
        }
    }
}
