//
//  ZZContainerDelegate.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa

protocol ZZContainerDelegate: NSObjectProtocol {
    
    /// 重新登陆
    func doWebViewRelogin()
    
    /// 刷新
    func doWebViewReload()
    
}
