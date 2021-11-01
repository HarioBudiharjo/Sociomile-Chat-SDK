//
//  LoadingView.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 01/11/21.
//

import UIKit
import NVActivityIndicatorView

class LoadingView: UIView {

    @IBOutlet weak var loadingContentView: UIView!
    
    public var color: UIColor = UIColor.white {
        didSet {
            self.indicatorLoading.color = color
        }
    }
    
    private var indicatorLoading: LoadingIndicatorView = {
        LoadingIndicatorView(size: CGSize(width: 50, height: 50))
    }()
    
    public override func draw(_ rect: CGRect) {
        self.loadingContentView.addSubview(self.indicatorLoading)
    }
    
    public func startAnimating() {
        self.indicatorLoading.startAnimating()
    }
    
    public func stopAnimating() {
        self.indicatorLoading.stopAnimating()
    }

}
