//
//  ButtonGroupSwiftUIExampleViewController.swift
//  ComponentSystemExample
//
//  Created by Cascade on 10/10/25.
//

import UIKit
import SwiftUI
import ComponentSystem

final class ButtonGroupSwiftUIExampleViewController: UIViewController {
    private var hostingController: UIHostingController<ButtonGroupSwiftUIView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ButtonGroup (SwiftUI)"
        view.backgroundColor = .systemBackground
        
        let contentView = ButtonGroupSwiftUIView()
        let hosting = UIHostingController(rootView: contentView)
        hostingController = hosting
        
        addChild(hosting)
        view.addSubview(hosting.view)
        hosting.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        hostingController?.view.frame = view.bounds.inset(by: view.safeAreaInsets)
    }
}

private struct DemoOption: SWButtonGroupOptionable, Equatable {
    let title: String
    let id: String? = nil
    let value: Int
}

struct ButtonGroupSwiftUIView: View {
    enum Style: String, CaseIterable, Identifiable {
        case blueSingle = "Blue Single"
        case blueMultiple = "Blue Multiple"
        case blackRoundSingle = "BlackRound Single"
        case custom = "Custom"
        var id: String { rawValue }
    }
    
    // Controls
    @State private var selectedStyle: Style = .blueSingle
    @State private var isHorizontal: Bool = true
    @State private var spacing: Double = 8
    @State private var canCancel: Bool = false // for single cancelable
    @State private var keepOne: Bool = false   // for keeping one selected
    
    // States
    @State private var selectedSingle: DemoOption? = nil
    @State private var selectedMultiple: [DemoOption] = []
    @State private var disabledOptions: [DemoOption] = []
    
    private let options: [DemoOption] = [
        DemoOption(title: "옵션 1", value: 1),
        DemoOption(title: "옵션 2", value: 2),
        DemoOption(title: "옵션 3", value: 3),
        DemoOption(title: "옵션 4", value: 4),
    ]
    
    private var layoutType: SWButtonGroupLayoutType {
        isHorizontal ? .horizontal(spacing: CGFloat(spacing)) : .vertical(spacing: CGFloat(spacing))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                GroupBox("Controls") {
                    Picker("Style", selection: $selectedStyle) {
                        ForEach(Style.allCases) { style in
                            Text(style.rawValue).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Toggle("Horizontal", isOn: $isHorizontal)
                    HStack {
                        Text("Spacing: \(Int(spacing))")
                        Slider(value: $spacing, in: 0...24, step: 2)
                    }
                    
                    // Contextual options per style
                    switch selectedStyle {
                    case .blueSingle:
                        Toggle("CanCancel (Single)", isOn: $canCancel)
                    case .blueMultiple, .blackRoundSingle:
                        Toggle("Keep One Selected", isOn: $keepOne)
                    case .custom:
                        Toggle("Keep One Selected", isOn: $keepOne)
                    }
                }
                
                GroupBox("Preview") {
                    VStack(alignment: .leading, spacing: 12) {
                        switch selectedStyle {
                        case .blueSingle:
                            SWBlueBlockButtonSingleGroup(layoutType: layoutType,
                                                         canCancel: canCancel,
                                                         options: options,
                                                         selectedOption: $selectedSingle)
                        case .blueMultiple:
                            SWBlueBlockButtonMultipleGroup(layoutType: layoutType,
                                                          keepOne: keepOne,
                                                          options: options,
                                                          selectedOptions: $selectedMultiple)
                        case .blackRoundSingle:
                            SWBlackRoundButtonSingleGroup(layoutType: layoutType,
                                                          keepOne: keepOne,
                                                          options: options,
                                                          selectedOption: $selectedSingle)
                        case .custom:
                            customExample
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Quick actions / helpers (only relevant for Custom style where disabledOptions is used)
                if selectedStyle == .custom {
                    HStack(spacing: 12) {
                        Button("Reset Selections") {
                            selectedSingle = nil
                            selectedMultiple.removeAll()
                        }
                        Button(disabledOptions.contains(where: { $0.value == 1 }) ? "Enable 1" : "Disable 1") {
                            toggleDisabled(value: 1)
                        }
                        Button(disabledOptions.contains(where: { $0.value == 2 }) ? "Enable 2" : "Disable 2") {
                            toggleDisabled(value: 2)
                        }
                    }
                } else {
                    Button("Reset Selections") {
                        selectedSingle = nil
                        selectedMultiple.removeAll()
                    }
                }
            }
            .padding(16)
        }
    }
    
    private var customExample: some View {
        SWMultipleButtonGroup(layoutType: layoutType,
                              minimumSelectedCount: keepOne ? 1 : 0,
                              options: options,
                              selectedOptions: $selectedMultiple,
                              disabledOptions: $disabledOptions,
                              normalContent: { option in
            Text(option.title)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(.systemGray5))
                .foregroundStyle(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }, selectedContent: { option in
            HStack(spacing: 6) {
                Image(systemName: "checkmark.circle.fill")
                Text(option.title)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.accentColor)
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }, disabledContent: { option in
            HStack(spacing: 6) {
                Image(systemName: "xmark.circle")
                Text(option.title)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .foregroundStyle(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        })
    }
    
    private func toggleDisabled(value: Int) {
        if let target = options.first(where: { $0.value == value }) {
            if let idx = disabledOptions.firstIndex(of: target) {
                disabledOptions.remove(at: idx)
            } else {
                disabledOptions.append(target)
            }
        }
    }
}
