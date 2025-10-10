//
//  ButtonGroupUIKitExampleViewController.swift
//  ComponentSystemExample
//
//  Created by Cascade on 10/10/25.
//

import UIKit
import SwiftUI
import PinLayout
import FlexLayout
import ComponentSystem

final class ButtonGroupUIKitExampleViewController: UIViewController {
    private let containerView = UIView()
    private let hostContainerView = UIView()
    
    // UIKit controls
    private let layoutSegment = UISegmentedControl(items: ["Horizontal", "Vertical"]) // layout
    private let spacingStepper = UIStepper() // spacing
    private let spacingValueLabel = UILabel()
    private let cancellableSwitch = UISwitch() // canCancel (for single)
    
    // Hosting SwiftUI content
    private var hostingController: UIHostingController<ButtonGroupUIKitContentView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ButtonGroup (UIKit)"
        view.backgroundColor = .systemBackground
        
        setupUI()
        setupLayout()
        bindActions()
        
        reloadHostedView()
    }
    
    private func setupUI() {
        // Segmented for layout
        layoutSegment.selectedSegmentIndex = 0
        
        // Spacing Stepper
        spacingStepper.minimumValue = 0
        spacingStepper.maximumValue = 24
        spacingStepper.stepValue = 2
        spacingStepper.value = 8
        
        spacingValueLabel.textColor = .secondaryLabel
        spacingValueLabel.font = .systemFont(ofSize: 14)
        spacingValueLabel.text = "8"
        
        // canCancel default OFF
        cancellableSwitch.isOn = false
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        
        containerView.flex.padding(16).rowGap(12).define { flex in
            flex.addItem(OptionView(title: "Layout", subview: layoutSegment))
            flex.addItem(OptionView(title: "Spacing", subviews: [spacingStepper, spacingValueLabel]))
            flex.addItem(OptionView(title: "CanCancel", subview: cancellableSwitch))
            
            // Host container for SwiftUI content
            flex.addItem(hostContainerView).grow(1)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.pin.all(view.pin.safeArea)
        containerView.flex.layout(mode: .adjustHeight)
        hostContainerView.pin.all()
        if let hosted = hostingController?.view {
            hosted.pin.all()
        }
    }
    
    private func bindActions() {
        layoutSegment.addTarget(self, action: #selector(controlChanged), for: .valueChanged)
        spacingStepper.addTarget(self, action: #selector(controlChanged), for: .valueChanged)
        cancellableSwitch.addTarget(self, action: #selector(controlChanged), for: .valueChanged)
    }
    
    @objc private func controlChanged() {
        spacingValueLabel.text = "\(Int(spacingStepper.value))"
        reloadHostedView()
    }
    
    private func currentLayoutType() -> SWButtonGroupLayoutType {
        let spacing = CGFloat(spacingStepper.value)
        if layoutSegment.selectedSegmentIndex == 0 {
            return .horizontal(spacing: spacing)
        } else {
            return .vertical(spacing: spacing)
        }
    }
    
    private func reloadHostedView() {
        // Remove existing hosting controller if any
        if let hosting = hostingController {
            hosting.willMove(toParent: nil)
            hosting.view.removeFromSuperview()
            hosting.removeFromParent()
        }
        
        let contentView = ButtonGroupUIKitContentView(layoutType: currentLayoutType(), canCancel: cancellableSwitch.isOn)
        let hosting = UIHostingController(rootView: contentView)
        hostingController = hosting
        
        addChild(hosting)
        hostContainerView.addSubview(hosting.view)
        hosting.didMove(toParent: self)
        
        // Layout hosting view using Pin/Flex
        hosting.view.backgroundColor = .clear
    }
}

// MARK: - SwiftUI content used by UIKit VC

private struct DemoOption: SWButtonGroupOptionable, Equatable {
    let title: String
    let id: String? = nil
    let value: Int
}

struct ButtonGroupUIKitContentView: View {
    @State private var selectedSingle: DemoOption? = nil
    @State private var selectedMultiple: [DemoOption] = []
    @State private var disabledOptions: [DemoOption] = []
    
    let layoutType: SWButtonGroupLayoutType
    let canCancel: Bool
    
    private let options: [DemoOption] = [
        DemoOption(title: "옵션 1", value: 1),
        DemoOption(title: "옵션 2", value: 2),
        DemoOption(title: "옵션 3", value: 3),
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Single Select (Blue Block)").font(.headline)
                SWBlueBlockButtonSingleGroup(layoutType: layoutType,
                                             canCancel: canCancel,
                                             options: options,
                                             selectedOption: $selectedSingle)
                
                Divider()
                
                Text("Multiple Select").font(.headline)
                SWMultipleButtonGroup(layoutType: layoutType,
                                      options: options,
                                      selectedOptions: $selectedMultiple,
                                      disabledOptions: $disabledOptions,
                                      normalContent: { option in
                    Text(option.title)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray5))
                        .foregroundStyle(.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }, selectedContent: { option in
                    Text(option.title)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.accentColor)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }, disabledContent: { option in
                    Text(option.title)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .foregroundStyle(Color.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                })
                
                // Toggle disabled example (first option)
                Button(action: toggleDisabledFirst) {
                    Text(disabledOptions.contains(where: { $0.value == 1 }) ? "Enable 첫번째 옵션" : "Disable 첫번째 옵션")
                }
                .padding(.top, 8)
            }
            .padding(16)
        }
    }
    
    private func toggleDisabledFirst() {
        if let first = options.first {
            if let idx = disabledOptions.firstIndex(of: first) {
                disabledOptions.remove(at: idx)
            } else {
                disabledOptions.append(first)
            }
        }
    }
}
