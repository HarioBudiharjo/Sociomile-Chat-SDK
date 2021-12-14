//
//  WebViewController.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 04/11/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {
    
    var url: URL?
    @IBOutlet weak var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            wkWebView.load(URLRequest(url: url))
        }
        wkWebView.allowsBackForwardNavigationGestures = true
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.exitAction))
        self.view.addGestureRecognizer(gesture)
    }

    @objc func exitAction(sender : UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
}
