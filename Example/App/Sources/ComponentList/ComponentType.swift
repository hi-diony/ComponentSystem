//
//  ComponentType.swift
//  ComponentSystemExample
//
//  Created by Station3 on 9/12/25.
//  Copyright © 2025 ComponentSystem. All rights reserved.
//


enum ComponentType: CaseIterable {
    case toast
    case buttonGroupUIKit
    case buttonGroupSwiftUI
    
    var title: String {
        switch self {
        case .toast: "토스트 (UIKit)"
        case .buttonGroupUIKit: "버튼 그룹 (UIKit)"
        case .buttonGroupSwiftUI: "버튼 그룹 (SwiftUI)"
        }
    }
}
