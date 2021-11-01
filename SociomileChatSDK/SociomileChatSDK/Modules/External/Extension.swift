//
//  Extension.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 01/11/21.
//

import Foundation
import UIKit

extension UIApplication {
    
    static func jsonString(from object:Any) -> String? {
        
        guard let data = jsonData(from: object) else {
            return nil
        }
        
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    static func jsonData(from object:Any) -> Data? {
        
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        
        return data
    }
    
    
}

extension UITableView {
    
    static func emptyCell() -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollToBottom(animated: Bool = true) {
        
        DispatchQueue.main.async {
            
            var yOffset: CGFloat = 0.0;

            if (self.contentSize.height > self.bounds.size.height) {
                yOffset = self.contentSize.height - self.bounds.size.height;
            }
            
            self.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
        }
    }
}

