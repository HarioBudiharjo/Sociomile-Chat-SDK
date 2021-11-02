//
//  ChatViewController.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 21/10/21.
//

import UIKit
import SocketIO
import MobileCoreServices

class ChatViewController: UIViewController {
    
    var token: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var imageChat = UIImage()

    let network = ChatNetwork()
    
    var chats: [Chat] = [] {
        didSet {
            tableView.reloadData()
            self.scrollToBottom()
        }
    }
    
    var isTyping: Bool = false {
        didSet {
            if isTyping {
                let typingCell = Chat(id: 0, name: "", message: "Typing...", date: "")
                chats.append(typingCell)
            } else {
                self.removeTypingCell()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        chatTextField.delegate = self
        self.imagePicker.delegate = self
        
        self.registerTableView()
        SocketHelper.shared.configureSocketClient(token: self.token)
        SocketHelper.shared.establishConnection()
        SocketHelper.shared.getMessage { chat in
            if let chat = chat {
                self.chats.append(chat)
            }
        } typingCompletion: { typing in
            if typing && !self.isTyping {
                self.isTyping = true
            } else {
                self.isTyping = false
            }
        }


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
        self.optionGetFile()
    }
    
    @IBAction func sendAction(_ sender: Any) {
        sendMessage()
    }
    
    private func sendDummyChat() {
        let chat = Chat(id: 1, name: "hario", message: "123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai", date: "123")
        let chat2 = Chat(id: 2, name: "hario", message: "123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai", date: "123")
        chats.append(chat)
        chats.append(chat2)
    }
    
    private func optionGetFile() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let documentAction = UIAlertAction(title: "Document", style: .default) { (action) in
            let importMenu = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .import)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            self.present(importMenu, animated: true, completion: nil)
        }
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = false
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }


        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        actionSheet.addAction(documentAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func sendImage() {
        let imageData = imageChat.jpegData(compressionQuality: 0.1)
        if let data = imageData {
            network.uploadPhoto(file: data, token: token) { result in
                switch result {
                case .success(let data):
                    if let data = data {
                        self.sendFileSocket(data: data)
                    }
                case .failure(let error):
                    self.showToast(message: "Error : \(error)")
                }
            }
        }
    }
    
    private func sendFileSocket(data: ChatDAO) {
//        {
//           "id":1635791770317,
//           "content":"ei_16357917543151431503378.jpg",
//           "file":{
//              "extension":"jpg",
//              "name":64104,
//              "type":"image"
//           },
//           "is_file":true,
//           "date":"2021-11-01T18:36:10.317Z",
//           "is_left":true
//        }
        let id = String(NSDate().timeIntervalSince1970)
        let today = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = formatter1.string(from: today)
        
        let dataMessage: [String:Any] = [
            "id":"\(id)",
            "content":"image.jpg",
            "file": [
                "extension" : data.data?.dataExtension ?? "",
                "name": data.data?.name ?? 0,
                "type": data.data?.type ?? ""
            ],
            "is_file":true,
            "date":"\(date)",
            "is_left": true
        ]
        SocketHelper.shared.sendMessage(message: dataMessage) {
            chats.append(Chat(id: 2, name: "", message: chatTextField.text ?? "", date: date))
            chatTextField.text = ""
        }
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
            chats.append(Chat(id: 2, name: "", message: chatTextField.text ?? "", date: date))
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
        var tempChat: [Chat] = []
        chats.forEach { chat in
            if chat.id != 0 {
                tempChat.append(chat)
            }
        }
        chats = tempChat
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

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageChat = pickedImage
            self.sendImage()
//            profileImage.contentMode = .scaleAspectFit
//            profileImage.image = pickedImage
//            presenter?.savePhoto(avatar: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController: UIDocumentPickerDelegate{

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let documentURL = urls.first else {
               return
        }

    }
}
