//
//  ZZViewExts.swift
//  ZZJDCookieGetter
//
//  Created by Sands on 2025/7/7.
//

import Cocoa

// MARK: - Tag String

private var tagStringKey: UInt8 = 0

extension NSView {
    
    var tagString: String? {
        get { objc_getAssociatedObject(self, &tagStringKey) as? String }
        set { objc_setAssociatedObject(self, &tagStringKey, newValue, .OBJC_ASSOCIATION_COPY) }
    }
    
    func viewWithTagString(_ tagString: String) -> NSView? {
        for subview in self.subviews {
            if subview.tagString == tagString {
                return subview
            }
            if let found = subview.viewWithTagString(tagString) {
                return found
            }
        }
        return nil
    }
    
}

// MARK: - HUD && Toast

enum ZZToastPosition: Int {
    case Top
    case Center
    case Bottom
}

let ZZ_HUD_VIEW_IDENTIFIER = "ZZ_HUD_VIEW_IDENTIFIER"
let ZZ_TOAST_VIEW_IDENTIFIER = "ZZ_TOAST_VIEW_IDENTIFIER"
/// 正在展示的HUD
var showingHUDViews: [NSView] = []

extension NSView: @retroactive NSAnimationDelegate {
    
    func showHUD(_ infoText: String? = nil) {
        guard self.bounds.width > 0 && self.bounds.height > 0 else {
            return
        }
        let padding = 16.0
        let maxContentWidth = self.bounds.width * 0.6
        let startRectSize = padding * 2
        let startRectX = self.bounds.midX - padding
        let startRectY = self.bounds.midY - padding
        let startRect = NSRect(x: startRectX, y: startRectY, width: startRectSize, height: startRectSize)
        let endRect = self.bounds
        
        let hudView = NSView(frame: startRect)
        hudView.tagString = ZZ_HUD_VIEW_IDENTIFIER
        hudView.wantsLayer = true
        hudView.layer?.backgroundColor = NSColor.hex(0x333230, alpha: 0.5).cgColor
        self.addSubview(hudView)
        
        let indicator = NSProgressIndicator(frame: startRect)
        indicator.style = .spinning
        indicator.isIndeterminate = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimation(nil)
        hudView.addSubview(indicator)
        let indicatorCenterX = NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: hudView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let indicatorCenterY = NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: hudView, attribute: .centerY, multiplier: 1.0, constant: 0)
        hudView.addConstraints([indicatorCenterX, indicatorCenterY])
        
        if let msg = infoText {
            let msgText = NSTextField(labelWithString: msg)
//            msgText.wantsLayer = true
//            msgText.layer?.backgroundColor = NSColor.red.cgColor
            msgText.textColor = NSColor.white
            msgText.font = NSFont.systemFont(ofSize: 12)
            msgText.alignment = .center
            msgText.lineBreakMode = .byWordWrapping
            msgText.usesSingleLineMode = false
            msgText.maximumNumberOfLines = 4
            msgText.cell?.truncatesLastVisibleLine = true
            msgText.translatesAutoresizingMaskIntoConstraints = false
            let boundedMsgRect = (msg as NSString).boundingRect(with: NSSize(width: maxContentWidth, height: CGFLOAT_MAX), options: .usesLineFragmentOrigin, attributes: [.font: NSFont.systemFont(ofSize: 14, weight: .medium)], context: nil)
            let msgRectWidth = boundedMsgRect.width + padding * 2 + 8.0 // plus 8.0 for fix emojis
            let msgRectHeight = boundedMsgRect.height + padding + 8.0 // plus 8.0 for fix emojis
            let msgRectX = (self.bounds.width - msgRectWidth) * 0.5
            let msgRectY = self.bounds.maxY - self.bounds.height * 0.5 - msgRectHeight
            msgText.frame = NSRect(x: msgRectX, y: msgRectY, width: msgRectWidth, height: msgRectHeight)
            hudView.addSubview(msgText)
            let msgCenterX = NSLayoutConstraint(item: msgText, attribute: .centerX, relatedBy: .equal, toItem: hudView, attribute: .centerX, multiplier: 1.0, constant: 0)
            let msgTop = NSLayoutConstraint(item: msgText, attribute: .top, relatedBy: .equal, toItem: hudView, attribute: .centerY, multiplier: 1.0, constant: padding * 2)
            hudView.addConstraints([msgTop, msgCenterX])
        }
        
        let animation = NSViewAnimation(duration: 0.1, animationCurve: .easeInOut)
        animation.delegate = self
        animation.viewAnimations = [
            [.target: hudView as Any, .startFrame: startRect as Any, .endFrame: endRect as Any, .effect: NSViewAnimation.EffectName.fadeIn]
        ]
        animation.start()
    }
    
    func dismissHUD() {
        var hudView: NSView? = nil
        if let lastHUDView = showingHUDViews.last {
            hudView = lastHUDView
        } else if let tagHUDView = self.viewWithTagString(ZZ_HUD_VIEW_IDENTIFIER) {
            hudView = tagHUDView
        }
        guard let finalHUDView = hudView else { return }
        let startRect = finalHUDView.frame
        let endRect: NSRect = .zero
        let dismissAnimation = NSViewAnimation(duration: 0.1, animationCurve: .easeInOut)
        dismissAnimation.delegate = self
        dismissAnimation.viewAnimations = [
            [.target: finalHUDView as Any, .startFrame: startRect as Any, .endFrame: endRect as Any, .effect: NSViewAnimation.EffectName.fadeOut]
        ]
        dismissAnimation.start()
    }
    
    
    func showToast(_ msg: String, inPos: ZZToastPosition = .Center) {
        guard self.bounds.width > 0 && self.bounds.height > 0 else {
            return
        }
        let padding = 16.0
        let startRectSize = padding * 2
        let startRectX = self.bounds.midX - padding
        var startRectY = self.bounds.midY - padding
        if inPos == .Top {
            startRectY = self.bounds.maxY
        } else if inPos == .Bottom {
            startRectY = self.bounds.minY
        }
        let startRect = NSRect(x: startRectX, y: startRectY, width: startRectSize, height: startRectSize)
        let maxContentWidth = self.bounds.width * 0.6
        var endRectWidth = maxContentWidth + padding * 2
        var endRectHeight: CGFloat = 0
        
        let toastView = NSView(frame: startRect)
        toastView.tagString = ZZ_TOAST_VIEW_IDENTIFIER
        toastView.wantsLayer = true
        toastView.layer?.backgroundColor = NSColor.hex(0xF0F0F0).cgColor
        toastView.layer?.cornerRadius = 4.0
        toastView.layer?.masksToBounds = true
        
        let toastText = NSTextField(labelWithString: msg)
        toastText.textColor = NSColor.black
        toastText.font = NSFont.systemFont(ofSize: 14, weight: .medium)
        toastText.alignment = .center
        toastText.lineBreakMode = .byWordWrapping
        toastText.usesSingleLineMode = false
        toastText.maximumNumberOfLines = 10
        toastText.cell?.truncatesLastVisibleLine = true
        toastText.translatesAutoresizingMaskIntoConstraints = false
        let boundedErrorMsgRect = (msg as NSString).boundingRect(with: NSSize(width: maxContentWidth, height: CGFLOAT_MAX), options: .usesLineFragmentOrigin, attributes: [.font: NSFont.systemFont(ofSize: 14, weight: .medium)], context: nil)
        endRectWidth = boundedErrorMsgRect.width + padding * 2 + 8.0 // plus 8.0 for fix emojis
        endRectHeight = boundedErrorMsgRect.height + padding + 8.0 // plus 8.0 for fix emojis
        
        toastView.addSubview(toastText)
        let endRectX = startRectX - endRectWidth * 0.5
        var endRectY = startRectY - endRectHeight * 0.5
        if inPos == .Top {
            endRectY = startRectY - endRectHeight - 8.0
        } else if inPos == .Bottom {
            endRectY = startRectY + 8.0
        }
        let endRect = NSRect(x: endRectX, y: endRectY, width: endRectWidth, height: endRectHeight)
        self.addSubview(toastView)
        
        let toastTextLeading = NSLayoutConstraint(item: toastText, attribute: .leading, relatedBy: .equal, toItem: toastView, attribute: .leading, multiplier: 1.0, constant: padding)
        let toastTextTrailing = NSLayoutConstraint(item: toastText, attribute: .trailing, relatedBy: .equal, toItem: toastView, attribute: .trailing, multiplier: 1.0, constant: -padding)
        let toastTextCenterY = NSLayoutConstraint(item: toastText, attribute: .centerY, relatedBy: .equal, toItem: toastView, attribute: .centerY, multiplier: 1.0, constant: 0)
        toastView.addConstraints([toastTextLeading, toastTextTrailing, toastTextCenterY])
        
        let animation = NSViewAnimation(duration: 0.1, animationCurve: .easeInOut)
        animation.delegate = self
        animation.viewAnimations = [
            [.target: toastView as Any, .startFrame: startRect as Any, .endFrame: endRect as Any, .effect: NSViewAnimation.EffectName.fadeIn]
        ]
        animation.start()
    }
    
    // MARK: - NSAnimationDelegate
    public nonisolated func animationShouldStart(_ animation: NSAnimation) -> Bool {
        print("$$---> animationShouldStart: \(Date().timeIntervalSince1970)")
        return true
    }
    
    public nonisolated func animationDidEnd(_ animation: NSAnimation) {
        print("$$---> animationDidEnd: \(Date().timeIntervalSince1970)")
        guard let viewAnimation = animation as? NSViewAnimation,
              let animationInfo = viewAnimation.viewAnimations.first,
              let target = animationInfo[.target] as? NSView,
              let startRect = animationInfo[.startFrame],
              let endRect = animationInfo[.endFrame],
              let effectName = animationInfo[.effect] as? NSViewAnimation.EffectName else { return }
        DispatchQueue.main.async {
            guard let tagString = target.tagString, tagString.count > 0 else { return }
            if tagString == ZZ_HUD_VIEW_IDENTIFIER {
                if effectName == .fadeIn {
                    showingHUDViews.append(target)
                } else if effectName == .fadeOut {
                    if let idx = showingHUDViews.firstIndex(of: target) {
                        showingHUDViews.remove(at: idx)
                    }
                    target.removeFromSuperview()
                }
            } else if tagString == ZZ_TOAST_VIEW_IDENTIFIER {
                if effectName == .fadeIn {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        let dismissAnimation = NSViewAnimation(duration: 0.1, animationCurve: .easeInOut)
                        dismissAnimation.delegate = self
                        dismissAnimation.viewAnimations = [
                            [.target: target, .startFrame: endRect as Any, .endFrame: startRect as Any, .effect: NSViewAnimation.EffectName.fadeOut]
                        ]
                        dismissAnimation.start()
                    }
                } else if effectName == .fadeOut {
                    target.removeFromSuperview()
                }
            }
        }
    }
    
}


