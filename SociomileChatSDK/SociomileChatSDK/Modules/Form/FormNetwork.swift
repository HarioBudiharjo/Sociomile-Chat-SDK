//
//  FormNetwork.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 25/10/21.
//

import Alamofire

class FormNetwork {
    func checkLogin(data: Form, completionHandler: @escaping (Result<String, Error>) -> Void) {
        AF.request("", method: .post, parameters: data, encoder: JSONParameterEncoder.default).response { response in
            debugPrint(response)
        }
    }
}
