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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var headerRoundedView: UIView!
    
    var imagePicker = UIImagePickerController()
    var imageChat = UIImage()
    var docChat = Data()
    var fileUrlTemp: URL?
    var docUrlTemp: URL?

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
                let typingCell = Chat(id: 0, name: "", message: "Typing...", imageUrl: nil, documentUrl: nil, date: "", type: .message)
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
        
        self.setView()
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
    
    override func viewDidAppear(_ animated: Bool) {
        if Preferences.getBool(key: Constant.CLOSE) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func setView() {
        self.tableView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        self.headerRoundedView.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        self.setTheme()
    }
    
    public func setTheme() {
        if Preferences.getString(key: Constant.THEME) == Theme.red.rawValue {
            self.headerView.backgroundColor = Color.red
            self.sendButton.backgroundColor = Color.red
        } else {
            self.headerView.backgroundColor = Color.blue
            self.sendButton.backgroundColor = Color.blue
        }
        self.sendButton.setTitle("", for: .normal)
    }
    
    private func registerTableView() {
        
        tableView.register(UINib(nibName: String(describing: MessageChatCell.self), bundle: SociomileRouter.bundle()), forCellReuseIdentifier: String(describing: MessageChatCell.self))
        tableView.register(UINib(nibName: String(describing: ReceivedChatCell.self), bundle: SociomileRouter.bundle()), forCellReuseIdentifier: String(describing: ReceivedChatCell.self))
        tableView.register(UINib(nibName: String(describing: ImageChatCell.self), bundle: SociomileRouter.bundle()), forCellReuseIdentifier: String(describing: ImageChatCell.self))
        tableView.register(UINib(nibName: String(describing: ReceivedImageChatCell.self), bundle: SociomileRouter.bundle()), forCellReuseIdentifier: String(describing: ReceivedImageChatCell.self))
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
    
    @IBAction func backAction(_ sender: Any) {
        SociomileRouter.goToExit(self)
    }
    
    @IBAction func uploadImageAction(_ sender: Any) {
        self.optionGetFile()
    }
    
    @IBAction func sendAction(_ sender: Any) {
//        sendDummyChat()
        sendMessage()
    }
    
    private func sendDummyChat() {
        //MARK: Message
        let chat = Chat(id: 1, name: "hario", message: "123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai", imageUrl: nil, documentUrl: nil, date: "123", type: .message)
        let chat2 = Chat(id: 2, name: "hario", message: "123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai", imageUrl: nil, documentUrl: nil, date: "123", type: .message)
        
        //MARK: Document
        let chatDoc = Chat(id: 1, name: "hario", message: "123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai", imageUrl: nil, documentUrl: nil, date: "123", type: .document)
        let chatDoc2 = Chat(id: 1, name: "hario", message: "123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai", imageUrl: nil, documentUrl: nil, date: "123", type: .document)
        
        //MARK: Image
        let chatImage = Chat(id: 2, name: "hario", message: "123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai", imageUrl: nil, documentUrl: nil, date: "123", type: .image)
        let chatImage2 = Chat(id: 2, name: "hario", message: "123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai123 ku mulai", imageUrl: nil, documentUrl: nil, date: "123", type: .image)
        
        chats.append(chat)
        chats.append(chat2)
        chats.append(chatDoc)
        chats.append(chatDoc2)
        chats.append(chatImage)
        chats.append(chatImage2)
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
                        self.sendFileSocket(data: data, file: .image)
                    }
                case .failure(let error):
                    self.showToast(message: "Error : \(error)")
                }
            }
        }
    }
    
    private func sendDoc() {
        network.uploadFile(file: docChat, token: token) { result in
            switch result {
            case .success(let data):
                if let data = data {
                    self.sendFileSocket(data: data, file: .document)
                }
            case .failure(let error):
                self.showToast(message: "Error : \(error)")
            }
        }
    }
    
    private func sendFileSocket(data: ChatDAO, file: FileType) {
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
        var content = ""
        if file.rawValue == FileType.document.rawValue {
            content = "doc.pdf"
        }
        if file.rawValue == FileType.image.rawValue {
            content = "image.jpg"
        }
        
        let dataMessage: [String:Any] = [
            "id":"\(id)",
            "content":content,
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
            if file.rawValue == TypeMessage.image.rawValue {
                chats.append(Chat(id: 2, name: "", message: "", imageUrl: self.fileUrlTemp, documentUrl: nil, date: date, type: .image))
                chatTextField.text = ""
            } else if file.rawValue == TypeMessage.document.rawValue {
                chats.append(Chat(id: 2, name: "", message: "Document", imageUrl: nil, documentUrl: self.docUrlTemp, date: date, type: .document))
                chatTextField.text = ""
            }
            else {
                chats.append(Chat(id: 2, name: "", message: chatTextField.text ?? "", imageUrl: nil, documentUrl: nil, date: date, type: .message))
                chatTextField.text = ""
            }
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
            chats.append(Chat(id: 2, name: "", message: chatTextField.text ?? "", imageUrl: nil, documentUrl: nil, date: date, type: .message))
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
            switch chats[indexPath.row].type {
            case .image,.document:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReceivedImageChatCell.self)) as? ReceivedImageChatCell else {
                    return UITableView.emptyCell()
                }
                cell.setView(data: chats[indexPath.row])
                cell.delegate = self
                return cell
            case .message:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReceivedChatCell.self)) as? ReceivedChatCell else {
                    return UITableView.emptyCell()
                }
                cell.setView(data: chats[indexPath.row])
                return cell
            }
        } else {
            switch chats[indexPath.row].type {
            case .image,.document:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImageChatCell.self)) as? ImageChatCell else {
                    return UITableView.emptyCell()
                }
                cell.delegate = self
                cell.setView(data: chats[indexPath.row])
                return cell
            case .message:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MessageChatCell.self)) as? MessageChatCell else {
                    return UITableView.emptyCell()
                }
                cell.setView(data: chats[indexPath.row])
                return cell
            }
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.imageChat = pickedImage
            self.sendImage()
        }
        
        if #available(iOS 11.0, *) {
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                self.fileUrlTemp = url
            }
        } else {
            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                self.fileUrlTemp = url
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ChatViewController: UIDocumentPickerDelegate{

    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let documentURL = urls.first else {
               return
        }
        print("document : \(documentURL)")
        self.docUrlTemp = documentURL
        do {
            let data = try Data(contentsOf: documentURL)
            docChat = data
            self.sendDoc()
        } catch {
            print("error data")
        }
    }
}

extension ChatViewController: ImageChatDelegate {
    func openWebView(url: URL?) {
        if let url = url {
            SociomileRouter.goToWebView(self, url: url)
        }
    }
}

extension ChatViewController: ReceivedImageChatDelegate {
    func download(url: URL?) {
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
    
    func open(url: URL?) {
        if let url = url {
            SociomileRouter.goToWebView(self, url: url)
        }
    }
}
