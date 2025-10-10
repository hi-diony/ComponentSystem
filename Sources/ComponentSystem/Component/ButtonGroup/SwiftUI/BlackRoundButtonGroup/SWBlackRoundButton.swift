//
//  SWBlackRoundButton.swift
//  DesignSystem
//
//  Created by Station3 on 8/14/25.
//  Copyright © 2025 kr.co.station3.Dabang. All rights reserved.
//

import SwiftUI

struct SWBlackRoundButton<Option: SWButtonGroupOptionable>: View {
    let option: Option
    let isSelected: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Text(option.title)
                .foregroundStyle(isSelected ? .white : .gray)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(isSelected ? .black : .gray.opacity(0.2))
        .cornerRadius(14)
    }
}
