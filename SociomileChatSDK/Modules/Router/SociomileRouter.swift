//
//  SociomileRouter.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 21/10/21.
//

import Foundation
import UIKit

public enum Theme: String {
    case blue = "blue"
    case red = "red"
}

public class SociomileRouter {
    
    public static func goToForm(_ caller: UIViewController) {
        let storyboard = UIStoryboard(name: "Chat", bundle: SociomileRouter.bundle())
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: FormViewController.self)) as! FormViewController
        vc.modalPresentationStyle = .fullScreen
        caller.present(vc, animated: true)
    }
    
    public static func goToChat(_ caller: UIViewController, token: String) {
        let storyboard = UIStoryboard(name: "Chat", bundle: SociomileRouter.bundle())
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: ChatViewController.self)) as! ChatViewController
        vc.token = token
        vc.modalPresentationStyle = .fullScreen
        caller.present(vc, animated: true)
    }
    
    public static func goToExit(_ caller: UIViewController) {
        let storyboard = UIStoryboard(name: "Chat", bundle: SociomileRouter.bundle())
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: ExitViewController.self)) as! ExitViewController
        vc.modalPresentationStyle = .fullScreen
        caller.present(vc, animated: true)
    }
    
    public static func goToWebView(_ caller: UIViewController, url: URL) {
        let storyboard = UIStoryboard(name: "Chat", bundle: SociomileRouter.bundle())
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: WebViewController.self)) as! WebViewController
        vc.url = url
        vc.modalPresentationStyle = .fullScreen
        caller.present(vc, animated: true)
    }
    
    public static func setFloatingButton(_ caller: UIViewController,_ callerView: UIView, theme: Theme, clientId: String) {
        let viewFloating: FloatingButtonView = UIView.fromNib()
        viewFloating.setData(theme: theme, clientId: clientId, caller: caller)
        let borderWidth = 2.0
        viewFloating.layer.borderColor = #colorLiteral(red: 0.9466721416, green: 0.9410444498, blue: 0.950997889, alpha: 1)
        viewFloating.layer.borderWidth = CGFloat(borderWidth)
        viewFloating.layer.cornerRadius = 5

        callerView.addSubview( viewFloating)
        viewFloating.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            viewFloating.trailingAnchor.constraint(equalTo: callerView.trailingAnchor, constant: -16.0),
            viewFloating.bottomAnchor.constraint(equalTo: callerView.bottomAnchor, constant: -16.0)
        ])
        callerView.setNeedsLayout()
    }
    
    public static func bundle() -> Bundle {
        let podBundle = Bundle(for: SociomileRouter.self)
        let bundleURL = podBundle.url(forResource: "SociomileChatSDK", withExtension: "bundle")
        if bundleURL == nil {
            return podBundle
        } else {
            return Bundle(url: bundleURL!)!
        }
    }
}
