//
//  FormViewController.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 21/10/21.
//

import UIKit

class FormViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var messageText: UITextView!
    let network = FormNetwork()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func exitAction(_ sender: Any) {
        
    }
    @IBAction func submitAction(_ sender: Any) {
        checkForm()
    }
    
    private func checkForm() {
        
        guard let name = nameTextField.text, !name.isEmpty,
        let email = emailTextField.text, !email.isEmpty,
        let phone = phoneNumberTextField.text, !phone.isEmpty,
        let message = messageText.text, !message.isEmpty else {
            print("Error belum diisi")
            return
        }
        
        let dataForm = Form(
            id: Preferences.getString(key: Constant.CLIENT_ID),
            name: name,
            email: email,
            phone: phone,
            message: message
        )
        network.checkForm(data: dataForm) { result in
            switch result {
            case .success(let data):
                if data.status ?? false {
                    self.checkAgent()
                } else {
                    print("err")
                }
            case .failure(let err):
                print("err : \(err)")
            }
        }
    }
    
    private func checkAgent() {
        network.checkAvailable(clientId: Preferences.getString(key: Constant.CLIENT_ID)) { result in
            switch result {
            case .success(let data):
                if data.data?.status ?? false {
                    self.login()
                } else {
                    print("client gk ada")
                }
            case .failure(let err):
                print("err : \(err)")
            }
        }
    }
    
    private func login() {
        guard let name = nameTextField.text, !name.isEmpty,
        let email = emailTextField.text, !email.isEmpty,
        let phone = phoneNumberTextField.text, !phone.isEmpty,
        let message = messageText.text, !message.isEmpty else {
            print("Error belum diisi")
            return
        }
        
        let dataForm = Form(
            id: Preferences.getString(key: Constant.CLIENT_ID),
            name: name,
            email: email,
            phone: phone,
            message: message
        )
        
        network.login(data: dataForm) { result in
            
            switch result {
            case .success(let data):
                print("data : \(data)")
            case .failure(let err):
                print("err : \(err)")
            }
        }
    }
}
