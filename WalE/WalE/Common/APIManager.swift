//
//  APIManager.swift
//  WalE
//
//  Created by sanket ingole on 01/12/21.
//

import Foundation

class APIManager {
    
    class func prepareRequest(path: String) -> URLRequest? {
        if let url = URL.init(string: path) {
            return URLRequest.init(url: url)
        }
        return nil
    }
    
   class func getResponse<T: Codable>(request : URLRequest, responseType: T.Type, completion : @escaping (T?, Error?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(nil, error)
            } else if let responseData = data {
                let jsonDecoder = JSONDecoder.init()
                do {
                    let model = try jsonDecoder.decode(responseType.self, from: responseData)
                    completion(model, nil)
                } catch let parsingError {
                    completion(nil, parsingError)
                }
            }
        }
        dataTask.resume()
    }
    
}
