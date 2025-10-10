//
//  OptionView.swift
//  ComponentSystemExample
//
//  Created by Station3 on 10/10/25.
//  Copyright © 2025 ComponentSystem. All rights reserved.
//

import UIKit
import FlexLayout
import PinLayout

class OptionView: UIView {
    private let containerView = UIView()
    
    init(title: String, subviews: [UIView]) {
        super.init(frame: .zero)
        
        addSubview(containerView)
        containerView.flex.direction(.row).alignItems(.center).columnGap(8).define { flex in
            let label = UILabel()
            label.text = title + ":"
            label.textColor = .secondaryLabel
            flex.addItem(label)
            
            flex.addItem().direction(.row).alignItems(.center).columnGap(8).define { flex in
                subviews.forEach { subview in
                    flex.addItem(subview)
                }
            }
        }
    }
    
    init(title: String, subview: UIView) {
        super.init(frame: .zero)
        
        addSubview(containerView)
        containerView.flex.direction(.row).alignItems(.center).columnGap(8).define { flex in
            let label = UILabel()
            label.text = title + ":"
            label.textColor = .secondaryLabel
            flex.addItem(label)
            
            flex.addItem(subview)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.pin.all()
        containerView.flex.layout(mode: .adjustHeight)
    }
}
