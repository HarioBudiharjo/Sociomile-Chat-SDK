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
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.helloView.frame
        rectShape.position = self.helloView.center
        rectShape.path = UIBezierPath(roundedRect: self.helloView.bounds, byRoundingCorners: [.bottomLeft , .bottomRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath

        self.helloView.layer.backgroundColor = UIColor.red.cgColor
        self.helloView.layer.mask = rectShape
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
        Loading.share.show()
        network.checkForm(data: dataForm) { result in
            Loading.share.hide()
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
        Loading.share.show()
        network.checkAvailable(clientId: Preferences.getString(key: Constant.CLIENT_ID)) { result in
            Loading.share.hide()
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
        
        Loading.share.show()
        network.login(data: dataForm) { result in
            Loading.share.hide()
            switch result {
            case .success(let data):
                SociomileRouter.goToChat(self, token: data.data?.token ?? "")
                print("data : \(data)")
            case .failure(let err):
                print("err : \(err)")
            }
        }
    }
}
