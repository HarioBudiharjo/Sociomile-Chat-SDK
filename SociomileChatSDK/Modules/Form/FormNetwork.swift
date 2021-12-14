//
//  FormNetwork.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 25/10/21.
//

import Alamofire

class FormNetwork {
    
    let decode = JSONDecoder()
    
    func checkForm(data: Form, completionHandler: @escaping (Result<FormDAO, Error>) -> Void) {
        AF.request(Constant.BASEURL_CHECK + "check-form-login?id=\(data.id)", method: .post, parameters: data, encoder: JSONParameterEncoder.default).response { response in
            
            debugPrint(response)
            let decodeResponse = try? self.decode.decode(FormDAO.self, from: response.data!)
            guard let objectDecode = decodeResponse else {
                completionHandler(.failure(InfoError.failedDecode))
                return
            }
            
            completionHandler(.success(objectDecode))
        }
    }
    
    
    func checkAvailable(clientId: String, completionHandler: @escaping (Result<AgentDAO, Error>) -> Void) {
        AF.request(Constant.BASEURL_CHECK + "check?id=\(clientId)", method: .get).response { response in
            
            debugPrint(response)
            let decodeResponse = try? self.decode.decode(AgentDAO.self, from: response.data!)
            guard let objectDecode = decodeResponse else {
                completionHandler(.failure(InfoError.failedDecode))
                return
            }
            
            completionHandler(.success(objectDecode))
        }
    }
    
    func login(data: Form, completionHandler: @escaping (Result<LoginDAO, Error>) -> Void) {
        AF.request(Constant.BASEURL_CHECK + "login-standar?id=\(data.id)", method: .post, parameters: data, encoder: JSONParameterEncoder.default).response { response in
            debugPrint(response)
            let decodeResponse = try? self.decode.decode(LoginDAO.self, from: response.data!)
            guard let objectDecode = decodeResponse else {
                completionHandler(.failure(InfoError.failedDecode))
                return
            }
            
            completionHandler(.success(objectDecode))
        }
    }
    
    func uploadPhoto(file: Data, token: String) {
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Authorization": token
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(file, withName: "image" , fileName: "image.jpg", mimeType: "application/jpeg")
            },
            to: Constant.BASEURL_CHECK, method: .post , headers: headers)
            .response { response in
                if let data = response.data{
                    //handle the response however you like
                }
                
            }
    }
}
