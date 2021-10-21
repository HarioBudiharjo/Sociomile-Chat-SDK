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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SociomileRouter.goToForm(self)
    }
}

