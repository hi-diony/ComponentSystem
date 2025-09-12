import UIKit

class ButtonExampleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Buttons"
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Primary Button
        let primaryButton = UIButton(type: .system)
        primaryButton.setTitle("Primary Button", for: .normal)
        primaryButton.backgroundColor = .systemBlue
        primaryButton.setTitleColor(.white, for: .normal)
        primaryButton.layer.cornerRadius = 8
        primaryButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        
        // Secondary Button
        let secondaryButton = UIButton(type: .system)
        secondaryButton.setTitle("Secondary Button", for: .normal)
        secondaryButton.setTitleColor(.systemBlue, for: .normal)
        secondaryButton.layer.borderWidth = 1
        secondaryButton.layer.borderColor = UIColor.systemBlue.cgColor
        secondaryButton.layer.cornerRadius = 8
        secondaryButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        
        // Destructive Button
        let destructiveButton = UIButton(type: .system)
        destructiveButton.setTitle("Destructive Button", for: .normal)
        destructiveButton.setTitleColor(.systemRed, for: .normal)
        destructiveButton.layer.borderWidth = 1
        destructiveButton.layer.borderColor = UIColor.systemRed.cgColor
        destructiveButton.layer.cornerRadius = 8
        destructiveButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        
        // Disabled Button
        let disabledButton = UIButton(type: .system)
        disabledButton.setTitle("Disabled Button", for: .normal)
        disabledButton.setTitleColor(.systemGray, for: .normal)
        disabledButton.backgroundColor = .systemGray5
        disabledButton.layer.cornerRadius = 8
        disabledButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
        disabledButton.isEnabled = false
        
        // Icon Button
        let iconButton = UIButton(type: .system)
        iconButton.setTitle("Icon Button", for: .normal)
        iconButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        iconButton.tintColor = .systemYellow
        iconButton.setTitleColor(.label, for: .normal)
        iconButton.backgroundColor = .systemGray6
        iconButton.layer.cornerRadius = 8
        iconButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 24)
        iconButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        
        // Add buttons to stack view
        stackView.addArrangedSubview(primaryButton)
        stackView.addArrangedSubview(secondaryButton)
        stackView.addArrangedSubview(destructiveButton)
        stackView.addArrangedSubview(disabledButton)
        stackView.addArrangedSubview(iconButton)
        
        view.addSubview(stackView)
        
        // Center stack view
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
}
