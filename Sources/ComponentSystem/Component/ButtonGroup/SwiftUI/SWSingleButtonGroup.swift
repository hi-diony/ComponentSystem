//
//  SingleButtonGroup.swift
//  DesignSystem
//
//  Created by Station3 on 5/28/25.
//  Copyright © 2025 kr.co.station3.Dabang. All rights reserved.
//

import SwiftUI

public struct SWSingleButtonGroup<Option: Equatable, Content: View>: View {
    private let options: [Option]
    private var normalContent: (Option) -> Content
    private var selectedContent: (Option) -> Content
    private let canCancel: Bool
    private let layoutType: SWButtonGroupLayoutType
    
    @Binding public var selectedOption: Option?
    
    public init(layoutType: SWButtonGroupLayoutType,
                canCancel: Bool = false,
                options: [Option],
                selectedOption: Binding<Option?>,
                @ViewBuilder normalContent: @escaping (Option) -> Content,
                @ViewBuilder selectedContent: @escaping (Option) -> Content) {
        self.options = options
        self._selectedOption = selectedOption
        self.normalContent = normalContent
        self.selectedContent = selectedContent
        self.layoutType = layoutType
        self.canCancel = canCancel
    }
    
    private var buttonItem: some View {
        ForEach(Array(options.enumerated()), id: \.offset) { index, option in
            Button {
                if canCancel == true,
                    selectedOption == option {
                    selectedOption = nil
                }
                else {
                    selectedOption = option
                }
            } label: {
                if selectedOption == option {
                    selectedContent(option)
                }
                else {
                    normalContent(option)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    public var body: some View {
        switch layoutType {
        case .horizontal(let spacing):
            HStack(spacing: spacing) {
                buttonItem
            }
            
        case .vertical(let spacing):
            VStack(spacing: spacing) {
                buttonItem
            }
        }
    }
}


