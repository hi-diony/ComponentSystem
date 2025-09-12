//
//  ToastView.swift
//  ComponentSystem
//
//  Created by Station3 on 9/12/25.
//


import Combine
import UIKit
import FlexLayout
import PinLayout

final class ToastView: UIView {
    let text: String
    let bottomPadding: CGFloat

    private let containerView = UIView()
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(text: String,
         bottomPadding: CGFloat) {
        self.text = text
        self.bottomPadding = bottomPadding
        
        super.init(frame: .zero)
            
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        addSubview(containerView)
        
        containerView.pin.all()
        
        let maxWidthRatio: CGFloat = 280 / 320
        let screenWidth = UIScreen.main.bounds.width
        let maxWidth = screenWidth * maxWidthRatio
        
        containerView.flex.paddingHorizontal(10).paddingVertical(1).maxWidth(maxWidth).alignSelf(.center).define { flex in
            let lb = UILabel()
            lb.font = .systemFont(ofSize: 14)
            lb.text = text
            lb.numberOfLines = 0
            lb.textAlignment = .center
            lb.textColor = .white
            flex.addItem(lb)
        }
    
        Publishers.keyboardHeight
            .removeDuplicates()
            .sink { [weak self] keyboardHeight in
                guard let self = self else { return }
                self.updateBottomPadding(keyboardHeight: keyboardHeight)
            }
            .store(in: &cancellables)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        updateBottomPadding(keyboardHeight: KeyboardManager.shared.keyboardHeight)
    }
    
    private func updateBottomPadding(keyboardHeight: CGFloat) {
        guard let superview = superview else { return }
        
        let systemPadding = keyboardHeight <= 0 ? safeAreaInsets.bottom : keyboardHeight
        let totalPadding = systemPadding + bottomPadding
        
        let maxHeightRatio: CGFloat = 720 / 884
        let maxHeight = (UIScreen.main.bounds.height - totalPadding) * maxHeightRatio
        
        containerView.flex.maxHeight(maxHeight)
        containerView.flex.layout(mode: .adjustHeight)
        containerView.flex.layout(mode: .adjustWidth)
        
        frame = .init(origin: .init(x: (UIScreen.main.bounds.width - containerView.frame.width) / 2,
                                    y: UIScreen.main.bounds.height - totalPadding - containerView.frame.height),
                      size: containerView.frame.size)
        
        superview.setNeedsLayout()
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.superview?.setNeedsLayout()
        }
    }
}

