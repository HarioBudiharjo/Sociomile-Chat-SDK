//
//  Socket.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 26/10/21.
//

import Foundation
import SocketIO

final class SocketHelper: NSObject {
    
    static let shared = SocketHelper()
    
    private var manager: SocketManager?
    private var socket: SocketIOClient?
    
    override init() {
        super.init()
    }
    
    func configureSocketClient(token: String) {
        
        guard let url = URL(string: Constant.URL_SOCKET) else {
            return
        }
        
        manager = SocketManager(socketURL: url, config: [.log(true), .compress, .connectParams(["token":"\(token)"])])
        
        
        guard let manager = manager else {
            return
        }
        
//        socket = manager.socket(forNamespace: "/**********")
        socket = manager.defaultSocket
    }
    
    func establishConnection() {
        guard let socket = manager?.defaultSocket else{
            return
        }
        
        socket.connect()
    }
    
    func closeConnection() {
        guard let socket = manager?.defaultSocket else{
            return
        }
        socket.disconnect()
    }
    
    func sendMessage(message: [String:Any], completion: () -> Void) {
        
        guard let socket = manager?.defaultSocket else {
            return
        }
        
        socket.emit(Constant.EVENT_DATA, message)
        completion()
    }

    func getMessage(chatCompletion: @escaping (_ chat: Chat?) -> Void, typingCompletion: @escaping (_ typing: Bool) -> Void) {

        guard let socket = manager?.defaultSocket else {
            return
        }

        socket.on(Constant.EVENT_DATA) { (dataArray, socketAck) -> Void in

            print("data : \(dataArray)")
            
            guard let dataFirst = dataArray.first as? [String:Any] else {
                return
            }
            //MARK: Content
            if let message = dataFirst["content"] as? String, let date = dataFirst["date"] as? String {
                let chat = Chat(id: 1, name: dataFirst["name"] as? String ?? "", message: message, imageUrl: nil, documentUrl: nil, date: date, type: .message)
                chatCompletion(chat)
            }
            
            //MARK: Category
            if let category = dataFirst["category"] as? String {
                if category == "remove_typing" {
                    typingCompletion(false)
                }
                
                if category == "typing" {
                    typingCompletion(true)
                }
            }
        }
    }
}

