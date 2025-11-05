//
//  ZZRESTClient.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa
import Alamofire

enum ZZRESTClientError: Error {
    case parametersError
    case responseError
    case UnknowError
}

class ZZRESTClient: NSObject {
    
    func Get<T: Codable>(_ request: ZZRESTRequest, type: T.Type = T.self, completionHandler:@escaping ((T?, Error?) -> Void)) {
        var fixedUrlStr = request.url
        if fixedUrlStr.hasSuffix("/") {
            fixedUrlStr = String(fixedUrlStr.dropLast())
        }
        if let params = request.params, params.count > 0 {
            var query = ""
            for (key, value) in params {
                if let strValue = value as? String,
                    let encodedValue = strValue.urlEncoded() {
                    query.append("\(key)=\(encodedValue)&")
                } else if value is Int {
                    query.append("\(key)=\(value)&")
                }
            }
            if query.hasSuffix("&") {
                query = String(query.dropLast())
                fixedUrlStr = fixedUrlStr + "?" + query
            }
        }
        guard let _ = URL(string: fixedUrlStr) else { return }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if let token = request.token {
            headers.add(name: "Authorization", value: token)
        }
        if request.debugResponse {
            AF.request(fixedUrlStr, method: .get, parameters: nil, headers: headers).response { resp in
                if let data = resp.data {
                    let obj = try? JSONSerialization.jsonObject(with: data)
                    print("$$----> debugResponse: \(obj as Any)")
                }
            }
        } else {
            AF.request(fixedUrlStr, method: .get, parameters: nil, headers: headers).responseDecodable(of: type) { resp in
                switch resp.result {
                case let .success(model):
                    completionHandler(model, nil)
                case let .failure(error):
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    func Post<T: Codable>(_ request: ZZRESTRequest, type: T.Type = T.self, completionHandler:@escaping ((T?, Error?) -> Void)) {
        guard let url = URL(string: request.url) else { return }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if let token = request.token {
            headers.add(name: "Authorization", value: token)
        }
        var urlRequest = try! URLRequest(url: url, method: .post, headers: headers)
        if let params = request.params {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
        } else if let paramsList = request.paramsList {
            let jsonObjList = paramsList.compactMap { try! JSONSerialization.jsonObject(with: try! JSONEncoder().encode($0), options: .allowFragments) }
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: jsonObjList, options: .fragmentsAllowed)
        }
        if request.debugResponse {
            AF.request(urlRequest).response { resp in
                if let data = resp.data {
                    let obj = try? JSONSerialization.jsonObject(with: data)
                    print("$$----> debugResponse: \(obj as Any)")
                } else {
                    print("$$----> debugResponse: \(resp as Any)")
                }
            }
        } else {
            AF.request(urlRequest).responseDecodable(of: type) { resp in
                switch resp.result {
                case let .success(model):
                    completionHandler(model, nil)
                case let .failure(error):
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    func Put<T: Codable>(_ request: ZZRESTRequest, type: T.Type = T.self, completionHandler:@escaping ((T?, Error?) -> Void)) {
        guard let url = URL(string: request.url) else { return }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if let token = request.token {
            headers.add(name: "Authorization", value: token)
        }
        var urlRequest = try! URLRequest(url: url, method: .put, headers: headers)
        if let params = request.params {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
        } else if let paramsList = request.paramsList {
            let jsonObjList = paramsList.compactMap { try! JSONSerialization.jsonObject(with: try! JSONEncoder().encode($0), options: .allowFragments) }
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: jsonObjList, options: .fragmentsAllowed)
        }
        if request.debugResponse {
            AF.request(urlRequest).response { resp in
                if let data = resp.data {
                    let obj = try? JSONSerialization.jsonObject(with: data)
                    print("$$----> debugResponse: \(obj as Any)")
                }
            }
        } else {
            AF.request(urlRequest).responseDecodable(of: type) { resp in
                switch resp.result {
                case let .success(model):
                    completionHandler(model, nil)
                case let .failure(error):
                    completionHandler(nil, error)
                }
            }
        }
    }
    
    func Delete<T: Codable>(_ request: ZZRESTRequest, type: T.Type = T.self, completionHandler:@escaping ((T?, Error?) -> Void)) {
        guard let url = URL(string: request.url) else { return }
        var headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        if let token = request.token {
            headers.add(name: "Authorization", value: token)
        }
        var urlRequest = try! URLRequest(url: url, method: .delete, headers: headers)
        if let params = request.params {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
        } else if let paramsList = request.paramsList {
            let jsonObjList = paramsList.compactMap { try! JSONSerialization.jsonObject(with: try! JSONEncoder().encode($0), options: .allowFragments) }
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: jsonObjList, options: .fragmentsAllowed)
        }
        if request.debugResponse {
            AF.request(urlRequest).response { resp in
                if let data = resp.data {
                    let obj = try? JSONSerialization.jsonObject(with: data)
                    print("$$----> debugResponse: \(obj as Any)")
                }
            }
        } else {
            AF.request(urlRequest).responseDecodable(of: type) { resp in
                switch resp.result {
                case let .success(model):
                    completionHandler(model, nil)
                case let .failure(error):
                    completionHandler(nil, error)
                }
            }
        }
    }
    

}
