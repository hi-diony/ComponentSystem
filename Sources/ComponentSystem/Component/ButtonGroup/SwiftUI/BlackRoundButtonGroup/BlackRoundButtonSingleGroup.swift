//
//  BlackRoundButtonSingleGroup.swift
//  DesignSystem
//
//  Created by Station3 on 8/14/25.
//  Copyright © 2025 kr.co.station3.Dabang. All rights reserved.
//

import SwiftUI

public struct SWBlackRoundButtonSingleGroup<Option: SWButtonGroupOptionable>: View {
    private let options: [Option]
    private let keepOne: Bool
    private let layoutType: SWButtonGroupLayoutType
    
    @Binding public var selectedOption: Option?
    
    public init(layoutType: SWButtonGroupLayoutType = .vertical(spacing: 8),
                keepOne: Bool = false,
                options: [Option],
                selectedOption: Binding<Option?> = .constant(nil)) {
        self.options = options
        self._selectedOption = selectedOption
        self.layoutType = layoutType
        self.keepOne = keepOne
    }
    
    public var body: some View {
        SWMultipleButtonGroup(layoutType: layoutType,
                              minimumSelectedCount: keepOne ? 1 : 0,
                              options: options,
                              selectedOptions: .init(get: { selectedOption.flatMap { [$0] } ?? [] },
                                                     set: { selectedOption = $0.last }),
                              normalContent: { option in
            SWBlackRoundButton(option: option, isSelected: false)
                .id(option.id)
        },
                              selectedContent: { option in
            SWBlackRoundButton(option: option, isSelected: true)
                .id(option.id)
        })
    }
}
