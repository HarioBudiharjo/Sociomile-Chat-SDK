//
//  ChatViewController.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 21/10/21.
//

import UIKit
import SocketIO

class ChatViewController: UIViewController {
    
    var token: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    
    var chats: [Chat] = [] {
        didSet {
            tableView.reloadData()
            self.scrollToBottom()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        chatTextField.delegate = self
        
        self.registerTableView()
//        SocketHelper.shared.configureSocketClient(token: self.token)
//        SocketHelper.shared.establishConnection()
//        SocketHelper.shared.getMessage { chat in
//            print("chat : \(chat)")
//        } typingCompletion: { typing in
//            print("typing : \(typing)")
//        }


    }
    
    private func registerTableView() {
        
        tableView.register(UINib(nibName: String(describing: MessageChatCell.self), bundle: SociomileRouter.bundle()), forCellReuseIdentifier: String(describing: MessageChatCell.self))
        tableView.register(UINib(nibName: String(describing: ReceivedChatCell.self), bundle: SociomileRouter.bundle()), forCellReuseIdentifier: String(describing: ReceivedChatCell.self))
    }
    
    private func scrollToBottom() {
        if chats.isEmpty {
            return
        }
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chats.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @IBAction func uploadImageAction(_ sender: Any) {
        
    }
    
    @IBAction func sendAction(_ sender: Any) {
        let chat = Chat(id: 1, name: "hario", message: "123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai", date: "123")
        let chat2 = Chat(id: 2, name: "hario", message: "123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai", date: "123")
        chats.append(chat)
        chats.append(chat2)
//        sendMessage()
    }
    
    private func sendImage() {
        
    }
    
    private func sendMessage() {
        let id = String(NSDate().timeIntervalSince1970)
        
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter1.string(from: today)
        
        let dataMessage: [String:Any] = [
            "id":"\(id)",
            "content":"\(chatTextField.text ?? "")",
            "date":"\(date)",
            "is_customer":true,
            "is_agent": false,
            "is_left": true
        ]
        SocketHelper.shared.sendMessage(message: dataMessage) {
            chatTextField.text = ""
        }
    }
    
    
    private func onStopTyping() {
        let id = String(NSDate().timeIntervalSince1970)
        
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter1.string(from: today)
        
        let dataMessage: [String:Any] = [
            "id":"\(id)",
            "date":"\(date)",
            "justNotify":true,
            "isRemoveTyping": true,
            "is_left": true
        ]
        SocketHelper.shared.sendMessage(message: dataMessage) {
            print("sukses")
        }
    }
    
    private func addTypingCell() {
        
    }
    
    private func onStartTyping() {
        let id = String(NSDate().timeIntervalSince1970)
        
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter1.string(from: today)
        
        let dataMessage: [String:Any] = [
            "id":"\(id)",
            "date":"\(date)",
            "justNotify":true,
            "isTyping": true,
            "is_left": true
        ]
        SocketHelper.shared.sendMessage(message: dataMessage) {
            print("sukses")
        }
    }
    
    private func removeTypingCell() {
        
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.onStartTyping()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.onStopTyping()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.onStopTyping()
    }
}


extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if chats[indexPath.row].id < 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReceivedChatCell.self)) as? ReceivedChatCell else {
                return UITableView.emptyCell()
            }
            cell.setView(data: chats[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageChatCell.self)) as? MessageChatCell else {
                return UITableView.emptyCell()
            }
            cell.setView(data: chats[indexPath.row])
            return cell
        }
    }
    
    
}
