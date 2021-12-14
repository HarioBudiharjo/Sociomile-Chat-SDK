//
//  FloatingButtonView.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 02/11/21.
//

import UIKit

class FloatingButtonView: UIView {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var floatingImage: UIImageView!
    
    var caller: UIViewController?
    var clientId = ""
    var theme: Theme = .red
    
    @IBAction func goToFormAction(_ sender: Any) {
        if let vc = caller {
            SociomileRouter.goToForm(vc)
        }
    }
    
    public func setData(theme: Theme, clientId: String, caller: UIViewController) {
        self.clientId = clientId
        self.theme = theme
        self.caller = caller
        
//        self.mainView.roundCorners(corners: [.topRight, .topLeft, .bottomLeft, .bottomRight], radius: 20)
//        self.layer.cornerRadius = self.frame.size.width/2
//        self.clipsToBounds = true
//
//
//        self.layer.borderColor = UIColor.gray.cgColor
//        self.layer.borderWidth = 5.0
        
        if theme == .red {
            floatingImage.image = UIImage(named: "red", in: SociomileRouter.bundle(), compatibleWith: nil)
        } else {
            floatingImage.image = UIImage(named: "blue", in: SociomileRouter.bundle(), compatibleWith: nil)
        }
        
        Preferences.saveString(key: Constant.CLIENT_ID, value: clientId)
        Preferences.saveString(key: Constant.THEME, value: theme.rawValue)
        
    }
}
