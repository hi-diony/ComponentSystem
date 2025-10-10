//
//  ToastWindow.swift
//  ComponentSystem
//
//  Created by Station3 on 9/12/25.
//

import UIKit

final class ToastWindow: UIWindow {
    static let shared = ToastWindow()
    
    private init() {
        if let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            super.init(windowScene: windowScene)
        }
        else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            super.init(windowScene: windowScene)
        }
        else {
            super.init(frame: UIScreen.main.bounds)
        }
        
        setupWindow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(view presentView: UIView, animated: Bool) {
        isHidden = false
        
        switch animated {
        case true:
            presentView.alpha = 0
            addSubview(presentView)
            
            UIView.animate(withDuration: 0.3) {
                presentView.alpha = 1
            }
            
        case false:
            presentView.alpha = 1
            addSubview(presentView)
        }
    }

    func hide(view presentView: UIView, animated: Bool) {
        switch animated {
        case true:
            UIView.animate(withDuration: 0.3, animations: {
                presentView.alpha = 0
                
            }, completion: { _ in
                presentView.removeFromSuperview()
            })
            
        case false:
            presentView.alpha = 0
            presentView.removeFromSuperview()
        }
    }
    
    private func setupWindow() {
        self.backgroundColor = .clear
        self.windowLevel = .alert + 1
        self.isUserInteractionEnabled = false
        self.isHidden = true
        self.rootViewController = UIViewController()
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)
        
        if (subviews.count - 1) <= 0 {
            isHidden = true
        }
    }
}

