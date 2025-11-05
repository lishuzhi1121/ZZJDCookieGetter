//
//  ZZQLSettingsHelper.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa

let ZZQL_URL_CACHE_KEY = "ZZQL_URL_CACHE_KEY"
let ZZQL_CLIENT_ID_CACHE_KEY = "ZZQL_CLIENT_ID_CACHE_KEY"
let ZZQL_CLIENT_SECRET_CACHE_KEY = "ZZQL_CLIENT_SECRET_CACHE_KEY"

let ZZQL_AUTH_MODEL_CACHE_KEY = "ZZQL_AUTH_MODEL_CACHE_KEY"

class ZZQLSettingsHelper: NSObject {
    
    var qlUrl: String? {
        return UserDefaults.standard.string(forKey: ZZQL_URL_CACHE_KEY)
    }
    
    var qlClientID: String? {
        return UserDefaults.standard.string(forKey: ZZQL_CLIENT_ID_CACHE_KEY)
    }
    
    var qlClientSecret: String? {
        return UserDefaults.standard.string(forKey: ZZQL_CLIENT_SECRET_CACHE_KEY)
    }
    
    var qlToken: String? {
        if let authModel = try? UserDefaults.standard.getObject(forKey: ZZQL_AUTH_MODEL_CACHE_KEY, castTo: ZZAuthModel.self), authModel.isEffective {
            return "\(authModel.token_type ?? "") \(authModel.token ?? "")"
        }
        return nil
    }
    
    
    static let shared = ZZQLSettingsHelper()
    
    public func saveSetting(_ key: String, value: String) {
        if key.count > 0 && value.count > 0 {
            UserDefaults.standard.set(value, forKey: key)
        }
    }
    
    public func refreshTokenIfNeed(_ completionHandler: @escaping (Bool) -> Void) {
        if let token = self.qlToken, token.count > 1 {
            completionHandler(true)
            return
        }
        guard let url = self.qlUrl,
              let _ = URL(string: url),
              let clientId = self.qlClientID,
              let clientSecret = self.qlClientSecret else {
            completionHandler(false)
            return
        }
        let authRequest = ZZRESTRequest(url, path: .Auth, params: [
            "client_id": clientId,
            "client_secret": clientSecret
        ])
        let authClient = ZZRESTClient()
        authClient.Get(authRequest, type: ZZRESTRespModel<ZZAuthModel>.self) { respModel, error in
            print("Get auth request: \(String(describing: respModel))")
            if let authModel = respModel?.data {
                try? UserDefaults.standard.setObject(authModel, forKey: ZZQL_AUTH_MODEL_CACHE_KEY)
                print("登陆成功🎉")
                completionHandler(true)
            } else {
                var errorMsg = error?.localizedDescription ?? "Unkonw error."
                if let msg = respModel?.message {
                    errorMsg = msg
                }
                print(errorMsg)
                completionHandler(false)
            }
        }
        
    }
    
}
