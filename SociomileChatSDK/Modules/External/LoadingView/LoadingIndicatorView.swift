//
//  LoadingIndicatorView.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 01/11/21.
//

import NVActivityIndicatorView
import UIKit

public class LoadingIndicatorView: UIView {
    private lazy var indicatorView: NVActivityIndicatorView = {
        NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), type: .ballBeat, color: UIColor.white, padding: 4)
    }()
    
    public convenience init(size: CGSize, color: UIColor = UIColor.white, padding: CGFloat = 4) {
        self.init()
        self.indicatorView.frame.size = size
        self.color = color
        self.padding = padding
        self.addSubview(self.indicatorView)
    }
    
    public var color: UIColor = UIColor.white {
        didSet {
            self.indicatorView.color = color
            self.startAnimating()
        }
    }
    
    public var padding: CGFloat = 4 {
        didSet {
            self.indicatorView.padding = padding
        }
    }
    
    public func startAnimating() {
        self.indicatorView.startAnimating()
    }
    
    public func stopAnimating() {
        self.indicatorView.stopAnimating()
    }
    
}
