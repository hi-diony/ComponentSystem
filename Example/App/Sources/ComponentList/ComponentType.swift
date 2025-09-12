//
//  ComponentType.swift
//  ComponentSystemExample
//
//  Created by Station3 on 9/12/25.
//  Copyright © 2025 ComponentSystem. All rights reserved.
//


enum ComponentType: CaseIterable {
    case toast
    
    var title: String {
        switch self {
        case .toast: "토스트"
        }
    }
}
