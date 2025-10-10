//
//  MultipleButtonGroup.swift
//  DesignSystem
//
//  Created by Station3 on 5/28/25.
//  Copyright © 2025 kr.co.station3.Dabang. All rights reserved.
//

import SwiftUI

public struct SWMultipleButtonGroup<Option: Equatable, Content: View>: View {
    private let options: [Option]
    private var normalContent: (Option) -> Content
    private var selectedContent: ((Option) -> Content)
    private var disabledContent: ((Option) -> Content)
    private let minimumSelectedCount: Int
    private let layoutType: SWButtonGroupLayoutType

    @Binding public var selectedOptions: [Option]
    @Binding public var disabledOptions: [Option]
    
    // deprecated!
    public init(
        layoutType: SWButtonGroupLayoutType,
        keepOne: Bool = false,
        options: [Option],
        selectedOptions: Binding<[Option]>,
        normalContent: @escaping (Option) -> Content,
        selectedContent: ((Option) -> Content)? = nil
    ) {
        self.options = options
        self._selectedOptions = selectedOptions
        self._disabledOptions = .constant([])
        self.normalContent = normalContent
        self.selectedContent = selectedContent ?? normalContent
        self.disabledContent = normalContent
        self.layoutType = layoutType
        self.minimumSelectedCount = keepOne ? 1 : 0
    }
    
    public init(
        layoutType: SWButtonGroupLayoutType,
        minimumSelectedCount: Int = 0,
        options: [Option],
        selectedOptions: Binding<[Option]> = .constant([]),
        disabledOptions: Binding<[Option]> = .constant([]),
        normalContent: @escaping (Option) -> Content,
        selectedContent: ((Option) -> Content)? = nil,
        disabledContent: ((Option) -> Content)? = nil
    ) {
        self.options = options
        self._selectedOptions = selectedOptions
        self._disabledOptions = disabledOptions
        self.normalContent = normalContent
        self.selectedContent = selectedContent ?? normalContent
        self.disabledContent = disabledContent ?? normalContent
        self.layoutType = layoutType
        self.minimumSelectedCount = minimumSelectedCount
    }

    private var buttonItem: some View {
        ForEach(Array(options.enumerated()), id: \.offset) { _, option in
            Button(action: {
                // 비활성화된 옵션은 클릭할 수 없음
                if disabledOptions.contains(option) {
                    return
                }
                
                if selectedOptions.contains(option) {
                    // 최소 선택 개수보다 많을 때만 제거 가능
                    if selectedOptions.count > minimumSelectedCount {
                        selectedOptions.removeAll { $0 == option }
                    }
                }
                else {
                    selectedOptions.append(option)
                }
            }) {
                if disabledOptions.contains(option) {
                    disabledContent(option)
                }
                else if selectedOptions.contains(option) {
                    selectedContent(option)
                }
                else {
                    normalContent(option)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(disabledOptions.contains(option))
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
