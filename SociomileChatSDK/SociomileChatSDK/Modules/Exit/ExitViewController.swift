//
//  ExitViewController.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 21/10/21.
//

import UIKit

class ExitViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var closeImage: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func closeAction(_ sender: Any) {
        Preferences.saveBool(key: Constant.CLOSE, value: true)
        self.dismiss(animated: false, completion: nil)
    }
}
