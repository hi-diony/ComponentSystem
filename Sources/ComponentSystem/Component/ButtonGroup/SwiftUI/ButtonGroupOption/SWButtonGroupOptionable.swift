//
//  SWButtonGroupOptionable.swift
//  DesignSystem
//
//  Created by Station3 on 5/28/25.
//  Copyright © 2025 kr.co.station3.Dabang. All rights reserved.
//


public protocol SWButtonGroupOptionable: Equatable {
    var title: String { get }
    var id: String? { get }
}

public extension SWButtonGroupOptionable {
    var id: String? { nil }
}
