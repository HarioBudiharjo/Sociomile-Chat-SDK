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
    @IBOutlet weak var numberView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    let network = FormNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Preferences.getBool(key: Constant.CLOSE) {
            Preferences.remove(key: Constant.CLOSE)
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func setView() {
        self.helloView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 15)
        self.numberView.roundCorners(corners: [.bottomLeft, .topLeft], radius: 10)
        
        self.messageText.layer.borderWidth = 1
        self.messageText.layer.borderColor = UIColor.gray.cgColor
        self.submitButton.layer.cornerRadius = 10
        
        self.setTheme()
    }
    
    public func setTheme() {
        if Preferences.getString(key: Constant.THEME) == Theme.red.rawValue {
            self.numberView.backgroundColor = Color.redYoung
            self.helloView.backgroundColor = Color.red
            self.submitButton.backgroundColor = Color.red
        } else {
            self.numberView.backgroundColor = Color.blueYoung
            self.helloView.backgroundColor = Color.blue
            self.submitButton.backgroundColor = Color.blue
        }
    }
    
    @IBAction func exitAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
