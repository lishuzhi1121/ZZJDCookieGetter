//
//  ZZQLEnvHelper.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/8.
//

import Cocoa

class ZZQLEnvHelper: NSObject {
    
    
    public static func getEnv(_ name: String? = nil, resultHandler:@escaping (([ZZEnvModel]?, Error?) -> Void)) {
        let searchClient = ZZRESTClient()
        var params: [String: Any] = [:]
        if let name = name {
            params["searchValue"] = name
        }
        let searchReq = ZZRESTRequest(path: .Envs, params: params)
        searchClient.Get(searchReq, type: ZZRESTRespModel<[ZZEnvModel]>.self) { respModel, error in
            resultHandler(respModel?.data, error)
        }
    }
    
    public static func addEnvs(_ envs: [ZZAddEnvModel], completionHandler:@escaping (([ZZEnvModel]?, Error?) -> Void)) {
        guard envs.count > 0 else {
            completionHandler(nil, nil)
            return
        }
        let addClient = ZZRESTClient()
        let addReq = ZZRESTRequest(path: .Envs, paramsList: envs)
//        addReq.debugResponse = true
        addClient.Post(addReq, type: ZZRESTRespModel<[ZZEnvModel]>.self) { respModel, error in
            completionHandler(respModel?.data, error)
        }
    }
    
    public static func updateEnv(_ env: ZZUpdateEnvModel, completionHandler:@escaping ((ZZEnvModel?, Error?) -> Void)) {
        guard let data = try? JSONEncoder().encode(env),
              let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
            return
        }
        let putClient = ZZRESTClient()
        let putReq = ZZRESTRequest(path: .Envs, params: jsonObj)
//        putReq.debugResponse = true
        putClient.Put(putReq, type: ZZRESTRespModel<ZZEnvModel>.self) { respModel, error in
            completionHandler(respModel?.data, error)
        }
    }
    
    public static func deleteEnvs(_ envs: [ZZEnvModel], completionHandler:@escaping ((ZZRESTRespModel<ZZEmptyModel>?, Error?) -> Void)) {
        guard envs.count > 0 else {
            completionHandler(nil, nil)
            return
        }
        let idsList = envs.compactMap { $0.ID }
        let deleteClient = ZZRESTClient()
        let deleteReq = ZZRESTRequest(path: .Envs, paramsList: idsList)
//        deleteReq.debugResponse = true
        deleteClient.Delete(deleteReq, type: ZZRESTRespModel<ZZEmptyModel>.self) { respModel, error in
            completionHandler(respModel, error)
        }
    }
    
    public static func enableEnvs(_ envs: [ZZEnvModel], completionHandler:@escaping ((ZZRESTRespModel<ZZEmptyModel>?, Error?) -> Void)) {
        guard envs.count > 0 else {
            completionHandler(nil, nil)
            return
        }
        let idsList = envs.compactMap { $0.ID }
        let putClient = ZZRESTClient()
        let putReq = ZZRESTRequest(path: .Enable, paramsList: idsList)
//        putReq.debugResponse = true
        putClient.Put(putReq, type: ZZRESTRespModel<ZZEmptyModel>.self) { respModel, error in
            completionHandler(respModel, error)
        }
    }
    
}
