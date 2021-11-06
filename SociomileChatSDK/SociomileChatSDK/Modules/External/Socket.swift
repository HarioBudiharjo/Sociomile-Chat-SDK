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
            
            //MARK: Document image / pdf
//            {
//               "stream_id":"618517db73bedb181026e290",
//               "project":5,
//               "ticket":"61851781801ddf3ee36e8d85",
//               "date":"2021-11-05 18:39:07",
//               "avatar":"",
//               "content":"rwa",
//               "attachments":[
//                  {
//                     "file":"livechat/2021/11/05/reply-e2cf8eb9eb0c0573f9905976e170477a.png",
//                     "fileName":"Screen Shot 2021-10-21 at 13.22.41.png",
//                     "name":"Screen Shot 2021-10-21 at 13.22.41.png",
//                     "path":"/tmp/php6EjiBV",
//                     "extension":"png",
//                     "contentType":"image/png",
//                     "url":"https://smcdn.s45.in/livechat/2021/11/05/reply-e2cf8eb9eb0c0573f9905976e170477a.png",
//                     "download":"https://smcdn.s45.in/livechat/2021/11/05/reply-e2cf8eb9eb0c0573f9905976e170477a.png"
//                  }
//               ]
//            }
            
            if let attachments = dataFirst["attachments"] as? [String:Any] {
                if let contentType = attachments["contentType"] as? String {
                    guard let name = attachments["name"] as? String, let urlAttch = attachments["url"] as? String, let url = URL(string: urlAttch), let date = dataFirst["date"] as? String else {
                        return
                    }
                    
                    if contentType.components(separatedBy: "/").count > 0 {
                        if contentType.components(separatedBy: "/")[0] == "image" {
                            //receive image
                            let chat = Chat(id: 1, name: "", message: name, imageUrl: url, documentUrl: nil, date: date, type: .image)
                            chatCompletion(chat)
                        }
                    }
                    if contentType == "application/pdf" {
                            let chat = Chat(id: 1, name: "", message: name, imageUrl: nil, documentUrl: url, date: date, type: .document)
                        chatCompletion(chat)
                    }
                }
            }
            //MARK: Document image
//            {
//               "stream_id":"6185195973bedb19c6251b89",
//               "project":5,
//               "ticket":"61851781801ddf3ee36e8d85",
//               "date":"2021-11-05 18:45:29",
//               "avatar":"",
//               "content":"tes",
//               "attachments":[
//                  {
//                     "file":"livechat/2021/11/05/reply-f44735ab8f3b96cd2912c8f9d9be0829.pdf",
//                     "fileName":"Untitled document.pdf",
//                     "name":"Untitled document.pdf",
//                     "path":"/tmp/phpEQrBi6",
//                     "extension":"pdf",
//                     "contentType":"application/pdf",
//                     "url":"https://smcdn.s45.in/livechat/2021/11/05/reply-f44735ab8f3b96cd2912c8f9d9be0829.pdf",
//                     "download":"https://smcdn.s45.in/livechat/2021/11/05/reply-f44735ab8f3b96cd2912c8f9d9be0829.pdf"
//                  }
//               ]
//            }
        }
    }
}

