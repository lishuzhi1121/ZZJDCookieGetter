//
//  ZZContainerViewController.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/4.
//

import Cocoa
import WebKit

class ZZContainerViewController: NSViewController {
    
    weak open var containerDelegate: (any ZZContainerDelegate)?
    
    @IBOutlet weak var jdCookieTextField: NSTextField!
    @IBOutlet weak var jdCookiesTableView: NSTableView!
    @IBOutlet weak var tableRefreshButton: NSButton!
    
    private let viewModel = ZZContainerViewModel()
    
    override func awakeFromNib() {
//        self.view.wantsLayer = true
//        self.view.layer?.backgroundColor = NSColor.hex(0xF0F0F0).cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupJDCookieField()
        setupJDCookiesTableView()
        
        ZZQLSettingsHelper.shared.refreshTokenIfNeed { [weak self] success in
            if success {
                self?.reloadTableView()
            }
        }
    }
    
    private func setupJDCookieField() {
        self.jdCookieTextField.delegate = self
        self.jdCookieTextField.focusRingType = .none
        self.jdCookieTextField.maximumNumberOfLines = 3
    }
    
    private func setupJDCookiesTableView() {
        jdCookiesTableView.columnAutoresizingStyle = .noColumnAutoresizing
        jdCookiesTableView.delegate = viewModel
        jdCookiesTableView.dataSource = viewModel
    }
    
    private func reloadTableView() {
        ZZQLEnvHelper.getEnv { [weak self] models, error in
            if let envModels = models {
                self?.viewModel.envModels = envModels
                self?.jdCookiesTableView.reloadData()
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        print("$$----> mouseDown: \(String(describing: event.window))")
        if let window = event.window {
            window.makeFirstResponder(nil)
        }
    }
    
    @IBAction func onClickQLSettingsButton(_ sender: NSButton) {
        let settingsVC = ZZQLSettingsViewController()
        settingsVC.testLoginCompletionClosure = { [weak self] success in
            if success {
                self?.reloadTableView()
            }
        }
        settingsVC.showInWindow(self, center: true, title: "QL Settings", identifier: "ZZ_QL_SETTINGS_WINDOW")
    }
    
    @IBAction func onClickRefreshButton(_ sender: NSButton) {
        self.containerDelegate?.doWebViewReload()
        if let window = self.view.window {
            window.makeFirstResponder(nil)
        }
    }
    @IBAction func onClickReLoginButton(_ sender: NSButton) {
        self.jdCookieTextField.stringValue = ""
        self.containerDelegate?.doWebViewRelogin()
        if let window = self.view.window {
            window.makeFirstResponder(nil)
        }
    }
    
    @IBAction func onClickSend2QLButton(_ sender: NSButton) {
        self.view.showHUD("加载中,请稍等...")
        let cookie = self.jdCookieTextField.stringValue
        guard let keyRange = cookie.range(of: "pt_key="), !keyRange.isEmpty,
           let pinRange = cookie.range(of: "pt_pin="), !pinRange.isEmpty else {
            self.view.showToast("JDCookie 格式不正确, 正确格式为: pt_key=xxx;pt_pin=xxx;")
            return
        }
        if let window = self.view.window {
            window.makeFirstResponder(nil)
        }
        
        ZZQLEnvHelper.getEnv("JD_COOKIE") { results, error in
            if let jdEnvModel = results?.first, jdEnvModel.ID > 0 {
                let newJDEnvModel = ZZUpdateEnvModel(ID: jdEnvModel.ID, name: jdEnvModel.name, value: cookie)
                ZZQLEnvHelper.updateEnv(newJDEnvModel) { [weak self] updateRes, error in
                    if let model = updateRes {
                        ZZQLEnvHelper.enableEnvs([model]) { [weak self] respModel, error in
                            print("$$---> 启用\(respModel?.code == 200 ? "成功🎉" : "失败☹️")")
                            self?.view.dismissHUD()
                            if let code = respModel?.code, code == 200 {
                                self?.showInfoToase("发送成功, 已启用🎉")
                                self?.reloadTableView()
                            } else {
                                self?.showInfoToase("环境变量: JD_COOKIE 启用失败☹️ Error: \(error?.localizedDescription ?? "")")
                            }
                        }
                    } else {
                        self?.view.dismissHUD()
                        self?.showInfoToase("环境变量: JD_COOKIE 更新失败☹️ Error: \(error?.localizedDescription ?? "")")
                    }
                }
            } else {
                self.view.showToast("未查询到环境变量: JD_COOKIE, 即将新增!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let jdEnv = ZZAddEnvModel(name: "JD_COOKIE", value: cookie, remarks: "京东Cookie")
                    ZZQLEnvHelper.addEnvs([jdEnv]) { [weak self] addRes, error in
                        if let models = addRes {
                            ZZQLEnvHelper.enableEnvs(models) { [weak self] respModel, error in
                                print("$$---> 启用\(respModel?.code == 200 ? "成功🎉" : "失败☹️")")
                                self?.view.dismissHUD()
                                if let code = respModel?.code, code == 200 {
                                    self?.showInfoToase("新增成功, 已启用🎉")
                                    self?.reloadTableView()
                                } else {
                                    self?.showInfoToase("环境变量: JD_COOKIE 启用失败☹️ Error: \(error?.localizedDescription ?? "")")
                                }
                            }
                        } else {
                            self?.view.dismissHUD()
                            self?.showInfoToase("环境变量: JD_COOKIE 新增失败☹️ Error: \(error?.localizedDescription ?? "")")
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func onClickTableRefreshButton(_ sender: NSButton) {
        reloadTableView()
    }
    
    private func showInfoToase(_ info: String) {
        DispatchQueue.main.async {
            self.view.showToast(info)
        }
    }
    
}

extension ZZContainerViewController: ZZWebDelegate {
    
    func webViewController(_ webViewController: ZZWebViewController, didFinish navigation: WKNavigation!, withCookie cookie: String?) {
        print("$$---> ZZContainerViewController: \(cookie ?? "")")
        DispatchQueue.main.async {
            self.jdCookieTextField.stringValue = cookie ?? ""
            self.jdCookieTextField.focusRingType = .none
        }
    }
    
}

extension ZZContainerViewController: NSTextFieldDelegate {
    
    func controlTextDidEndEditing(_ obj: Notification) {
        
    }
    
}
