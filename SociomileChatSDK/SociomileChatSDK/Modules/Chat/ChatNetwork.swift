//
//  ChatNetwork.swift
//  SociomileChatSDK
//
//  Created by Hario Budiharjo on 02/11/21.
//

import Alamofire

class ChatNetwork {
    func uploadPhoto(file: Data, token: String, completionHandler: @escaping (Result<ChatDAO?, Error>) -> Void) {
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer \(token)"
        ]
        
        AF.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(file, withName: "image" , fileName: "image.jpg", mimeType: "image/jpeg")
            },
            to: Constant.BASEURL_CHECK + "image", method: .post , headers: headers)
            .response { result in
                debugPrint(result)
                switch result.result {
                    
                case .success(let response):
                    if let response = response {
                        let decode = JSONDecoder()
                        let decodeResponse = try? decode.decode(ChatDAO.self, from: response)
                        completionHandler(.success(decodeResponse))
                    }
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
}
