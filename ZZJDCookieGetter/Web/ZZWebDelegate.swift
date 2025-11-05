//
//  ZZWebDelegate.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa
import WebKit

protocol ZZWebDelegate: NSObjectProtocol {
    
    func webViewController(_ webViewController: ZZWebViewController, didFinish navigation: WKNavigation!, withCookie cookie: String?)
    
}
