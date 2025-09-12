//
//  Toast.swift
//  ComponentSystem
//
//  Created by Station3 on 9/12/25.
//


import SwiftUI
import Combine

public struct Toast: Equatable {
    static var DefaultBottomPadding: CGFloat { 65 }

    let id: String = UUID().uuidString
    var isShowing: Bool
    let message: String
    let duration: TimeInterval
    let bottomPadding: CGFloat // bottom padding from safearea
    let queue: Bool
    
    public init(isShowing: Bool,
                message: String = "",
                duration: TimeInterval = 2,
                bottomPadding: CGFloat? = nil,
                queue: Bool = true) {
        self.isShowing = isShowing
        self.message = message
        self.duration = duration
        self.bottomPadding = bottomPadding ?? Self.DefaultBottomPadding
        self.queue = queue
    }

    public init(_ message: String,
                duration: TimeInterval = 2,
                additionalPadding: CGFloat = 0,
                queue: Bool = true) {
        self.isShowing = message.isEmpty == false
        self.message = message
        self.duration = duration
        self.bottomPadding = Self.DefaultBottomPadding + additionalPadding
        self.queue = queue
    }

    public init(text: String?,
                duration: TimeInterval = 2,
                additionalPadding: CGFloat = 0,
                queue: Bool = true) {
        let newText = text ?? ""
        self.isShowing = newText.isEmpty == false
        self.message = newText
        self.duration = duration
        self.bottomPadding = Self.DefaultBottomPadding + additionalPadding
        self.queue = queue
    }

    public func show() {
        ToastManager.shared.show(toast: self)
    }
    
    public func cancel() {
        ToastManager.shared.cancel(id: id)
    }
}
