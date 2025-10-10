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

    private let textView = UITextView()
    private let queueToggle = UISwitch()
    private let timeStepper = UIStepper()
    private let timeValueLabel = UILabel()
    private let additionalBottomPaddingStepper = UIStepper()
    private let additionalBottomPaddingTextField = UITextField()
       
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
        textView.returnKeyType = .done

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

        // additionalBottomPadding Stepper
        additionalBottomPaddingStepper.minimumValue = 0
        additionalBottomPaddingStepper.maximumValue = 200
        additionalBottomPaddingStepper.stepValue = 1
        additionalBottomPaddingStepper.value = 0

        // additionalBottomPadding TextField
        additionalBottomPaddingTextField.text = "\(Int(additionalBottomPaddingStepper.value))"
        additionalBottomPaddingTextField.borderStyle = .roundedRect
        additionalBottomPaddingTextField.keyboardType = .numberPad
        additionalBottomPaddingTextField.textAlignment = .center
        additionalBottomPaddingTextField.returnKeyType = .done
        
        // 버튼
        showToastButton.setTitle("Show Toast", for: .normal)
        showToastButton.backgroundColor = .systemBlue
        showToastButton.setTitleColor(.white, for: .normal)
        showToastButton.layer.cornerRadius = 8

        let textFieldToolbar = UIToolbar()
        textFieldToolbar.sizeToFit()
        let textFieldFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let textFieldDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(endEditingAction))
        textFieldToolbar.items = [textFieldFlexSpace, textFieldDoneButton]
        textView.inputAccessoryView = textFieldToolbar
    }

    private func setupLayout() {
        view.addSubview(containerView)

        containerView.flex.padding(16).rowGap(12).define { flex in
            flex.addItem(OptionView(title: "Queue", subview: queueToggle))
            flex.addItem(OptionView(title: "Time(초)", subviews: [timeStepper, timeValueLabel]))
            flex.addItem(OptionView(title: "AdditionalBottomPadding", subviews: [additionalBottomPaddingStepper, additionalBottomPaddingTextField]))
           
            flex.addItem(textView).height(100).border(1, .secondaryLabel)

            flex.addItem(showToastButton).height(50)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.pin.all(view.pin.safeArea)
        containerView.flex.layout()
    }

    private func bindActions() {
        timeStepper.addTarget(self, action: #selector(timeStepperChanged), for: .valueChanged)
        showToastButton.addTarget(self, action: #selector(didTapShowToast), for: .touchUpInside)
        additionalBottomPaddingStepper.addTarget(self, action: #selector(additionalBottomPaddingStepperChanged), for: .valueChanged)
    }

    @objc private func timeStepperChanged() {
        timeValueLabel.text = "\(timeStepper.value) s"
    }
    
    @objc private func additionalBottomPaddingStepperChanged() {
        additionalBottomPaddingTextField.text = "\(Int(additionalBottomPaddingStepper.value))"
    }

    @objc private func endEditingAction() {
        view.endEditing(true)
    }

    @objc private func didTapShowToast() {
        guard let text = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }

        let queue = queueToggle.isOn
        let duration = timeStepper.value // 초
        let additionalBottomPadding = additionalBottomPaddingStepper.value
        Toast(text, duration: duration, additionalPadding: additionalBottomPadding, queue: queue).show()
    }
}
