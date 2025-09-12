//
//  ToastOperation.swift
//  ComponentSystem
//
//  Created by Station3 on 9/12/25.
//


import Foundation

final class ToastOperation: Operation {
    static public var DefaultBottomPadding: CGFloat { 65 }

    private var toast: Toast
    private var toastView: ToastView? = nil
    
    override public var isAsynchronous: Bool { return true }

    private var _isExecuting: Bool = false
    private var _isFinished: Bool = false

    override var isExecuting: Bool {
        get { _isExecuting }
        set {
            willChangeValue(forKey: "isExecuting")
            _isExecuting = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }

    override var isFinished: Bool {
        get { _isFinished }
        set {
            willChangeValue(forKey: "isFinished")
            _isFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }

    init(toast: Toast) {
        self.toast = toast
        
        super.init()
        
        self.name = toast.id
        self.queuePriority = toast.queue ? .normal : .veryHigh
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }

        isExecuting = true
        main()
    }

    override func main() {
        guard isCancelled == false else {
            isFinished = true
            return
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                self?.isFinished = true
                return
            }

            let toastView = ToastView(
                text: self.toast.message,
                bottomPadding: self.toast.bottomPadding
            )
            self.toastView = toastView

            ToastWindow.shared.show(view: toastView, animated: true)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration) { [weak self] in
            guard let self = self else { return }
            guard let toastView = self.toastView else { return }
            ToastWindow.shared.hide(view: toastView, animated: true)
            
            self.toastView = nil
            self.toast.isShowing = false
            self.isFinished = true
        }
    }

    override func cancel() {
        if isCancelled {
            return
        }
        
        guard let toastView = toastView else {
            return
        }

        func superCancel() {
            super.cancel()
        }
        
        DispatchQueue.main.async {
            ToastWindow.shared.hide(view: toastView, animated: false)
        }
        
        superCancel()
        self.toastView = nil
        self.toast.isShowing = false
        self.isFinished = true
    }
}
