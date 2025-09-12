//
//  File.swift
//  ComponentSystem
//
//  Created by Station3 on 9/12/25.
//

import Foundation
import UIKit

public extension UIControl {
    func onTap(handler: @escaping () -> ()) {
        onTouchUpInside(handler: handler)
    }
    
    func onTouchUpInside(handler: @escaping () -> ()) {
        addAction(for: .touchUpInside, handler: handler)
    }
    
    func addAction(for event: UIControl.Event, handler: @escaping () -> ()) {
        let action = UIAction { _ in
            handler()
        }
        addAction(action, for: event)
    }
}
