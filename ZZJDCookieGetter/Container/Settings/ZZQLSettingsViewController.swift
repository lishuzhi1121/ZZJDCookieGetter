//
//  ZZQLSettingsViewController.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa

class ZZQLSettingsViewController: NSViewController {
    
    var testLoginCompletionClosure: ((Bool) -> (Void))?
    
    @IBOutlet weak var qlURLTextField: NSTextField!
    @IBOutlet weak var qlClientIDTextField: NSTextField!
    @IBOutlet weak var qlClientSecretTextField: NSTextField!
    
    override func awakeFromNib() {
//        self.view.wantsLayer = true
//        self.view.layer?.backgroundColor = NSColor.hex(0xF0F0F0).cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = ZZQLSettingsHelper.shared.qlUrl,
            let clientId = ZZQLSettingsHelper.shared.qlClientID,
            let clientSecret = ZZQLSettingsHelper.shared.qlClientSecret {
            self.qlURLTextField.stringValue = url
            self.qlClientIDTextField.stringValue = clientId
            self.qlClientSecretTextField.stringValue = clientSecret
            
            self.qlURLTextField.focusRingType = .none
            self.qlClientIDTextField.focusRingType = .none
            self.qlClientSecretTextField.focusRingType = .none
            
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        print("$$----> mouseDown: \(String(describing: event.window))")
        if let window = event.window,
            let identifier = window.identifier?.rawValue,
            identifier == "ZZ_QL_SETTINGS_WINDOW" {
            window.makeFirstResponder(nil)
        }
    }
    
    @IBAction func onClickTestLoginButton(_ sender: NSButton) {
        guard self.qlURLTextField.stringValue.count > 0 else {
            alertErrorInfo("青龙地址不能为空！")
            return
        }
        guard self.qlClientIDTextField.stringValue.count > 0 else {
            alertErrorInfo("青龙ClientID不能为空！")
            return
        }
        guard self.qlClientSecretTextField.stringValue.count > 0 else {
            alertErrorInfo("青龙ClientSecret不能为空！")
            return
        }
        guard URL(string: self.qlURLTextField.stringValue) != nil else {
            alertErrorInfo("青龙地址不合法！")
            return
        }
        let authRequest = ZZRESTRequest(self.qlURLTextField.stringValue, path: .Auth, params: [
            "client_id": self.qlClientIDTextField.stringValue,
            "client_secret": self.qlClientSecretTextField.stringValue
        ])
        let authClient = ZZRESTClient()
        authClient.Get(authRequest, type: ZZRESTRespModel<ZZAuthModel>.self) { [weak self] respModel, error in
            print("Get auth request: \(String(describing: respModel))")
            if let authModel = respModel?.data {
                try? UserDefaults.standard.setObject(authModel, forKey: ZZQL_AUTH_MODEL_CACHE_KEY)
                self?.view.showToast("登陆成功🎉", inPos: .Top)
                self?.testLoginCompletionClosure?(true)
            } else {
                var errorMsg = error?.localizedDescription ?? "Unkonw error."
                if let msg = respModel?.message {
                    errorMsg = msg
                }
                self?.view.showToast(errorMsg, inPos: .Top)
                self?.testLoginCompletionClosure?(false)
            }
        }
        
        
    }
    
    
    @IBAction func onClickSaveButton(_ sender: NSButton) {
        guard self.qlURLTextField.stringValue.count > 0 else {
            alertErrorInfo("青龙地址不能为空！")
            return
        }
        guard self.qlClientIDTextField.stringValue.count > 0 else {
            alertErrorInfo("青龙ClientID不能为空！")
            return
        }
        guard self.qlClientSecretTextField.stringValue.count > 0 else {
            alertErrorInfo("青龙ClientSecret不能为空！")
            return
        }
        guard URL(string: self.qlURLTextField.stringValue) != nil else {
            alertErrorInfo("青龙地址不合法！")
            return
        }
        
        ZZQLSettingsHelper.shared.saveSetting(ZZQL_URL_CACHE_KEY, value: self.qlURLTextField.stringValue)
        ZZQLSettingsHelper.shared.saveSetting(ZZQL_CLIENT_ID_CACHE_KEY, value: self.qlClientIDTextField.stringValue)
        ZZQLSettingsHelper.shared.saveSetting(ZZQL_CLIENT_SECRET_CACHE_KEY, value: self.qlClientSecretTextField.stringValue)
    }
    
    private func alertErrorInfo(_ info: String) {
        let alert = NSAlert()
        alert.alertStyle = .informational
        alert.messageText = "提示🔔"
        alert.informativeText = info
        alert.addButton(withTitle: "确定")
        alert.runModal()
    }
    
}
