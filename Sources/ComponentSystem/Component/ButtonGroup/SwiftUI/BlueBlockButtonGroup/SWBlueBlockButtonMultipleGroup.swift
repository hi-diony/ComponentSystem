//
//  SWBlueBlockButtonMultipleGroup.swift
//  DesignSystem
//
//  Created by Station3 on 5/28/25.
//  Copyright © 2025 kr.co.station3.Dabang. All rights reserved.
//

import SwiftUI

public struct SWBlueBlockButtonMultipleGroup<Option: SWButtonGroupOptionable>: View {
    private let options: [Option]
    private let keepOne: Bool
    private let layoutType: SWButtonGroupLayoutType
    
    @Binding public var selectedOptions: [Option]
    
    public init(layoutType: SWButtonGroupLayoutType = .vertical(spacing: 8),
                keepOne: Bool = false,
                options: [Option],
                selectedOptions: Binding<[Option]>) {
        self.options = options
        self._selectedOptions = selectedOptions
        self.layoutType = layoutType
        self.keepOne = keepOne
    }
    
    public var body: some View {
        SWMultipleButtonGroup(layoutType: layoutType,
                              keepOne: keepOne,
                              options: options,
                              selectedOptions: $selectedOptions,
                              normalContent: { option in
            SWBlockButton(option: option, isSelected: false)
                .id(option.id)
        },
                            selectedContent: { option in
            SWBlockButton(option: option, isSelected: true)
                .id(option.id)
        })
    }
}
