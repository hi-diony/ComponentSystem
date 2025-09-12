import UIKit

class TextFieldExampleViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Text Fields"
        
        setupScrollView()
        setupTextFields()
        
        // Add tap gesture to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupTextFields() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
        
        // Standard Text Field
        let standardField = createTextField(placeholder: "Standard Text Field")
        standardField.autocapitalizationType = .words
        stackView.addArrangedSubview(createFieldContainer(with: standardField, title: "Standard"))
        
        // Email Field
        let emailField = createTextField(placeholder: "email@example.com")
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        stackView.addArrangedSubview(createFieldContainer(with: emailField, title: "Email"))
        
        // Password Field
        let passwordField = createTextField(placeholder: "Enter password")
        passwordField.isSecureTextEntry = true
        passwordField.textContentType = .newPassword
        passwordField.rightView = createPasswordToggleButton(for: passwordField)
        passwordField.rightViewMode = .always
        stackView.addArrangedSubview(createFieldContainer(with: passwordField, title: "Password"))
        
        // Phone Number Field
        let phoneField = createTextField(placeholder: "(123) 456-7890")
        phoneField.keyboardType = .phonePad
        phoneField.textContentType = .telephoneNumber
        stackView.addArrangedSubview(createFieldContainer(with: phoneField, title: "Phone Number"))
        
        // Multiline Text View
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 1.0 / UIScreen.main.scale
        textView.layer.borderColor = UIColor.systemGray4.cgColor
        textView.layer.cornerRadius = 8
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        textView.delegate = self
        
        let textViewContainer = createFieldContainer(with: textView, title: "Multiline Text")
        textViewContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        stackView.addArrangedSubview(textViewContainer)
        
        // Search Field
        let searchField = createTextField(placeholder: "Search...")
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .systemGray
        
        let searchContainer = UIView()
        searchContainer.addSubview(searchIcon)
        searchContainer.addSubview(searchField)
        
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 12),
            searchIcon.centerYAnchor.constraint(equalTo: searchField.centerYAnchor),
            searchIcon.widthAnchor.constraint(equalToConstant: 20),
            searchIcon.heightAnchor.constraint(equalToConstant: 20),
            
            searchField.topAnchor.constraint(equalTo: searchContainer.topAnchor),
            searchField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
            searchField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor),
            searchField.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor)
        ])
        
        stackView.addArrangedSubview(createFieldContainer(with: searchContainer, title: "Search"))
    }
    
    private func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        textField.delegate = self
        return textField
    }
    
    private func createFieldContainer(with view: UIView, title: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        titleLabel.textColor = .secondaryLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(view)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createPasswordToggleButton(for textField: UITextField) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.setImage(UIImage(systemName: "eye"), for: .selected)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return button
    }
    
    @objc private func togglePasswordVisibility(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        // Find the password field in the view hierarchy
        if let container = sender.superview as? UIStackView {
            for subview in container.arrangedSubviews {
                if let textField = subview as? UITextField, textField.isSecureTextEntry {
                    textField.isSecureTextEntry = !sender.isSelected
                    break
                }
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension TextFieldExampleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate

extension TextFieldExampleViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
