//
//  ZZWebViewController.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa
import WebKit

let JD_LOGIN_URL = "https://home.m.jd.com/myJd/home.action"

class ZZWebViewController: NSViewController {
    
    weak open var webDelegate: (any ZZWebDelegate)?
    
    @IBOutlet weak var wkWebView: WKWebView!
    
    private var allCookies: [HTTPCookie] = []
    private var toDeleteCookies: [HTTPCookie] = []
    
    override func awakeFromNib() {
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.white.cgColor
        preferredContentSize = NSSize(width: 540.0 * 3.0 / 5.0, height: 540.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.wkWebView.navigationDelegate = self
        self.wkWebView.uiDelegate = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.makeJDLogin()
        }
    }
    
    // MARK: - Private
    
    private func makeJDLogin() {
        if let jdLoginUrl = URL(string: JD_LOGIN_URL) {
            let jdLoginRequest = URLRequest(url: jdLoginUrl)
            self.wkWebView.load(jdLoginRequest)
        }
    }
    
    private func clearAllCookies(_ completionHandler: @escaping (Bool) -> Void) {
        let cookieStore = self.wkWebView.configuration.websiteDataStore.httpCookieStore
        self.toDeleteCookies = self.allCookies
        deleteCookies(cookieStore) { [weak self] result in
            if result {
                self?.allCookies = []
                self?.toDeleteCookies = []
            }
            completionHandler(result)
        }
    }
    
    private func deleteCookies(_ cookieStore: WKHTTPCookieStore, completionHandler: @escaping (Bool) -> Void) {
        if let cookie = self.toDeleteCookies.first {
            cookieStore.delete(cookie) { [weak self] in
                self?.toDeleteCookies.removeFirst()
                self?.deleteCookies(cookieStore, completionHandler: completionHandler)
            }
        } else {
            completionHandler(true)
        }
    }
    
}

extension ZZWebViewController: ZZContainerDelegate {
    
    func doWebViewRelogin() {
        clearAllCookies { [weak self] success in
            if success {
                if let jdLoginUrl = URL(string: JD_LOGIN_URL) {
                    let jdLoginRequest = URLRequest(url: jdLoginUrl)
                    self?.wkWebView.load(jdLoginRequest)
                }
            } else {
                self?.wkWebView.reload()
            }
        }
    }
    
    func doWebViewReload() {
        self.wkWebView.reload()
    }
    
}

extension ZZWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let cookieStore = webView.configuration.websiteDataStore.httpCookieStore
        cookieStore.getAllCookies { [weak self] cookies in
            self?.allCookies = cookies
            var ptKeyValue = ""
            var ptPinValue = ""
            for cookie in cookies {
                if cookie.name == "pt_key" {
                    ptKeyValue = cookie.value
                }
                if cookie.name == "pt_pin" {
                    ptPinValue = cookie.value
                }
                if ptKeyValue.count > 0 && ptPinValue.count > 0 {
                    break
                }
            }
            print("$$---->pt_key=\(ptKeyValue);pt_pin=\(ptPinValue);<----$$")
            if ptKeyValue.count > 0 && ptPinValue.count > 0 {
                let jdCookieStr = "pt_key=\(ptKeyValue);pt_pin=\(ptPinValue);"
                self?.webDelegate?.webViewController(self!, didFinish: navigation, withCookie: jdCookieStr)
            }
        }
    }
    
}

extension ZZWebViewController: WKUIDelegate {
    
}
