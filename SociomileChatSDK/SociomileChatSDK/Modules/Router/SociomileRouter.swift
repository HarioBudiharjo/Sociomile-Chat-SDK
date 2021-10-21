//
//  SociomileRouter.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 21/10/21.
//

import Foundation
import UIKit

public class SociomileRouter {
    
    public static func goToForm(_ caller: UIViewController) {
        let storyboard = UIStoryboard(name: "Chat", bundle: SociomileRouter.bundle())
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: FormViewController.self)) as! FormViewController
        vc.modalPresentationStyle = .fullScreen
        caller.present(vc, animated: true)
    }
    
    public static func goToChat(_ caller: UIViewController) {
        let storyboard = UIStoryboard(name: "Chat", bundle: SociomileRouter.bundle())
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: ChatViewController.self)) as! ChatViewController
        vc.modalPresentationStyle = .fullScreen
        caller.present(vc, animated: true)
    }
    
    public static func goToExit(_ caller: UIViewController) {
        let storyboard = UIStoryboard(name: "Chat", bundle: SociomileRouter.bundle())
        let vc = storyboard.instantiateViewController(withIdentifier: String(describing: ExitViewController.self)) as! ExitViewController
        vc.modalPresentationStyle = .fullScreen
        caller.present(vc, animated: true)
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