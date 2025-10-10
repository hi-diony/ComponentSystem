//
//  SWButtonGroupOption.swift
//  DesignSystem
//
//  Created by Station3 on 5/28/25.
//  Copyright © 2025 kr.co.station3.Dabang. All rights reserved.
//


public struct SWButtonGroupOption<Value: Equatable>: SWButtonGroupOptionable {
    public var title: String
    public var value: Value
    public var id: String?
    
    public init(title: String, value: Value, id: String? = nil) {
        self.title = title
        self.value = value
        self.id = id
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.value == rhs.value
    }
}
