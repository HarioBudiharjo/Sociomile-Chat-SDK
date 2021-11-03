//
//  ViewController.swift
//  SociomileChatSDKApps
//
//  Created by Hario Budiharjo on 21/10/21.
//

import UIKit
import SociomileChatSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        SociomileRouter.goToForm(self)
        SociomileRouter.setFloatingButton(self, self.view, theme: .blue, clientId: "57c6e0e722c054db65f99267")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        SociomileRouter.goToChat(self, token: "")
//        SociomileRouter.goToForm(self)
//        SociomileRouter.goToExit(self)
    }
}

