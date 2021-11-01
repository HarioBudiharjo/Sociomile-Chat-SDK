//
//  FormViewController.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 21/10/21.
//

import UIKit
import SocketIO

class FormViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var helloView: UIView!
    
    
    let network = FormNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
    }
    
    private func setView() {
        self.helloView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
    
    @IBAction func exitAction(_ sender: Any) {
        print("exit")
    }
    
    @IBAction func submitAction(_ sender: Any) {
        checkForm()
    }
        
    private func checkForm() {
        
        guard let name = nameTextField.text, !name.isEmpty,
        let email = emailTextField.text, !email.isEmpty,
        let phone = phoneNumberTextField.text, !phone.isEmpty,
        let message = messageText.text, !message.isEmpty else {
            self.showToast(message: "Data form belum lengkap!")
            return
        }
        
        let dataForm = Form(
            id: Preferences.getString(key: Constant.CLIENT_ID),
            name: name,
            email: email,
            phone: phone,
            message: message
        )
        Loading.share.show()
        network.checkForm(data: dataForm) { result in
            Loading.share.hide()
            switch result {
            case .success(let data):
                if data.status ?? false {
                    self.checkAgent()
                } else {
                    self.showToast(message: "Data form salah!")
                }
            case .failure(let err):
                self.showToast(message: "Error : \(err)")
            }
        }
    }
    
    private func checkAgent() {
        Loading.share.show()
        network.checkAvailable(clientId: Preferences.getString(key: Constant.CLIENT_ID)) { result in
            Loading.share.hide()
            switch result {
            case .success(let data):
                if data.data?.status ?? false {
                    self.login()
                } else {
                    self.showToast(message: "Agent tidak tersedia!")
                }
            case .failure(let err):
                self.showToast(message: "Error : \(err)")
            }
        }
    }
    
    private func login() {
        guard let name = nameTextField.text, !name.isEmpty,
        let email = emailTextField.text, !email.isEmpty,
        let phone = phoneNumberTextField.text, !phone.isEmpty,
        let message = messageText.text, !message.isEmpty else {
            self.showToast(message: "Data form belum lengkap!")
            return
        }
        
        let dataForm = Form(
            id: Preferences.getString(key: Constant.CLIENT_ID),
            name: name,
            email: email,
            phone: phone,
            message: message
        )
        
        Loading.share.show()
        network.login(data: dataForm) { result in
            Loading.share.hide()
            switch result {
            case .success(let data):
                SociomileRouter.goToChat(self, token: data.data?.token ?? "")
            case .failure(let err):
                self.showToast(message: "Error : \(err)")
            }
        }
    }
}
