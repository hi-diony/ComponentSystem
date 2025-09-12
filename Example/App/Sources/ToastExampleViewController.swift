//
//  ToastViewController.swift
//  ComponentSystemExample
//
//  Created by Station3 on 9/12/25.
//  Copyright © 2025 ComponentSystem. All rights reserved.
//

import Foundation
import PinLayout
import FlexLayout
import UIKit
import ComponentSystem

//
//  ToastExampleViewController.swift
//  ComponentSystemExample
//
//  Created by Station3 on 9/12/25.
//  Copyright © 2025 ComponentSystem. All rights reserved.
//

import UIKit
import PinLayout
import FlexLayout
import ComponentSystem

final class ToastExampleViewController: UIViewController {
    private let containerView = UIView()

    private let textField = UITextField()
    private let queueToggle = UISwitch()
    private let timeStepper = UIStepper()
    private let timeValueLabel = UILabel()

    private let showToastButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        setupLayout()
        bindActions()
    }

    private func setupUI() {
        // TextField
        textField.placeholder = "typing toast text..."
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .done
        textField.addTarget(self, action: #selector(endEditingAction), for: .editingDidEndOnExit)

        // Queue Toggle (기본 OFF)
        queueToggle.isOn = false

        // Stepper (초 단위)
        timeStepper.minimumValue = 0.5
        timeStepper.maximumValue = 10
        timeStepper.stepValue = 0.5
        timeStepper.value = 2

        // 현재 초 표시 라벨
        timeValueLabel.textColor = .secondaryLabel
        timeValueLabel.font = .systemFont(ofSize: 14)
        timeValueLabel.textAlignment = .right
        timeValueLabel.text = "\(timeStepper.value) s"

        // 버튼
        showToastButton.setTitle("Show Toast", for: .normal)
        showToastButton.backgroundColor = .systemBlue
        showToastButton.setTitleColor(.white, for: .normal)
        showToastButton.layer.cornerRadius = 8

        // 배경 탭 시 키보드 내리기
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditingAction))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func setupLayout() {
        view.addSubview(containerView)

        containerView.flex.padding(16).rowGap(12).define { flex in
            // 1) Queue
            flex.addItem().direction(.row).alignItems(.center).columnGap(8).define { flex in
                let label = UILabel()
                label.text = "Queue:"
                label.textColor = .secondaryLabel

                flex.addItem(label)
                flex.addItem(queueToggle)
            }

            // 2) Time(초)
            flex.addItem().direction(.row).alignItems(.center).columnGap(8).define { flex in
                let label = UILabel()
                label.text = "Time(초):"
                label.textColor = .secondaryLabel

                flex.addItem(label)
                flex.addItem(timeStepper)
                flex.addItem(timeValueLabel).grow(1)
            }

            // 3) Text 입력
            flex.addItem(textField).height(44)

            // 4) 버튼
            flex.addItem(showToastButton).height(50)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.pin.all(view.pin.safeArea)
        containerView.flex.layout()
    }

    private func bindActions() {
        timeStepper.addTarget(self, action: #selector(stepperChanged), for: .valueChanged)
        showToastButton.addTarget(self, action: #selector(didTapShowToast), for: .touchUpInside)
    }

    @objc private func stepperChanged() {
        timeValueLabel.text = "\(timeStepper.value) s"
    }

    @objc private func endEditingAction() {
        view.endEditing(true)
    }

    @objc private func didTapShowToast() {
        endEditingAction()

        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              text.isEmpty == false else {
            // 빈 문자열 방지: 간단한 안내 토스트
            #if canImport(ComponentSystem)
            Toast("텍스트를 입력해주세요", queue: false).show()
            #endif
            return
        }

        let queue = queueToggle.isOn
        let duration = timeStepper.value // 초

        Toast(text, duration: duration, queue: queue).show()
    }
}
