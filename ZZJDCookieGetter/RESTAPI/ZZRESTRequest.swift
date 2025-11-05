//
//  ZZRESTRequest.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa

let ZZQL_AUTH_TOKEN_URL_PATH = "/open/auth/token"
let ZZQL_ENVS_URL_PATH = "/open/envs"


enum ZZRESTRequestPath: String {
    case Auth = "/open/auth/token"
    case Envs = "/open/envs"
    case Enable = "/open/envs/enable"
}

class ZZRESTRequest: NSObject {
    
    public var url: String {
        return urlStr
    }
    public var token: String? {
        return tokenStr
    }
    public var params: [String: Any]? {
        return paramsDict
    }
    public var paramsList: [Encodable]? {
        return paramsArr
    }
    public var debugResponse: Bool = false
    
    private var urlStr: String = ""
    private var paramsDict: [String: Any]? = nil
    private var paramsArr: [Encodable]? = nil
    private var tokenStr: String? = nil
    
    convenience init(_ url: String, params: [String: Any]? = nil, token: String? = nil) {
        self.init()
        self.urlStr = url
        self.paramsDict = params
        self.tokenStr = token
    }
    
    convenience init(_ host: String = ZZQLSettingsHelper.shared.qlUrl ?? "", path: ZZRESTRequestPath, params: [String: Any]? = nil) {
        self.init()
        var fixedHostStr = host
        if fixedHostStr.hasSuffix("/") {
            fixedHostStr = String(fixedHostStr.dropLast())
        }
        self.urlStr = fixedHostStr + path.rawValue
        self.paramsDict = params
        self.tokenStr = ZZQLSettingsHelper.shared.qlToken
    }
    
    convenience init(_ host: String = ZZQLSettingsHelper.shared.qlUrl ?? "", path: ZZRESTRequestPath, paramsList: [Encodable]? = nil) {
        self.init()
        var fixedHostStr = host
        if fixedHostStr.hasSuffix("/") {
            fixedHostStr = String(fixedHostStr.dropLast())
        }
        self.urlStr = fixedHostStr + path.rawValue
        self.paramsArr = paramsList
        self.tokenStr = ZZQLSettingsHelper.shared.qlToken
    }

}
