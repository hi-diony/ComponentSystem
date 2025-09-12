//
//  KeyboardManager.swift
//  ComponentSystem
//
//  Created by Station3 on 9/12/25.
//

import Combine
import Foundation

final class KeyboardManager {
    @MainActor public static let shared = KeyboardManager()
    
    public private(set) var keyboardHeight: CGFloat = 0
    private var cancellable: AnyCancellable?
    
    private init() {
        cancellable = Publishers.keyboardHeight
            .receive(on: RunLoop.main)
            .sink { [weak self] height in
                self?.keyboardHeight = height
            }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
