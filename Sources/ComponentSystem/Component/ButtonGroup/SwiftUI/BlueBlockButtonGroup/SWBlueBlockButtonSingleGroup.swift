//
//  SWBlueBlockButtonSingleGroup.swift
//  DesignSystem
//
//  Created by Station3 on 5/28/25.
//  Copyright © 2025 kr.co.station3.Dabang. All rights reserved.
//

import SwiftUI

public struct SWBlueBlockButtonSingleGroup<Option: SWButtonGroupOptionable>: View {
    private let options: [Option]
    private let canCancel: Bool
    private let layoutType: SWButtonGroupLayoutType
    
    @Binding public var selectedOption: Option?
    
    public init(layoutType: SWButtonGroupLayoutType = .vertical(spacing: 8),
                canCancel: Bool = false,
                options: [Option],
                selectedOption: Binding<Option?>) {
        self.options = options
        self._selectedOption = selectedOption
        self.layoutType = layoutType
        self.canCancel = canCancel
    }
    
    public var body: some View {
        SWSingleButtonGroup(layoutType: layoutType,
                            canCancel: canCancel,
                            options: options,
                            selectedOption: $selectedOption,
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
