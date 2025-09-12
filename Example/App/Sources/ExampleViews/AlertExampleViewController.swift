import UIKit

class AlertExampleViewController: UIViewController {
    
    private let buttonTitles = [
        "Show Simple Alert",
        "Show Alert with Text Field",
        "Show Action Sheet",
        "Show Destructive Alert",
        "Show Custom Alert"
    ]
    
    private let buttonStyles: [UIAlertAction.Style] = [
        .default,
        .default,
        .default,
        .destructive,
        .default
    ]
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Alerts & Action Sheets"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func showAlert(for index: Int) {
        switch index {
        case 0:
            showSimpleAlert()
        case 1:
            showAlertWithTextField()
        case 2:
            showActionSheet()
        case 3:
            showDestructiveAlert()
        case 4:
            showCustomAlert()
        default:
            break
        }
    }
    
    private func showSimpleAlert() {
        let alert = UIAlertController(
            title: "Simple Alert",
            message: "This is a simple alert with a message.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            print("OK tapped")
        })
        
        present(alert, animated: true)
    }
    
    private func showAlertWithTextField() {
        let alert = UIAlertController(
            title: "Sign In",
            message: "Enter your credentials",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Username"
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Sign In", style: .default) { [weak self] _ in
            let username = alert.textFields?[0].text ?? ""
            let password = alert.textFields?[1].text ?? ""
            print("Username: \(username), Password: \(password)")
        })
        
        present(alert, animated: true)
    }
    
    private func showActionSheet() {
        let actionSheet = UIAlertController(
            title: "Choose Option",
            message: "Select an option from below",
            preferredStyle: .actionSheet
        )
        
        let options = ["Option 1", "Option 2", "Option 3", "Cancel"]
        
        for (index, option) in options.enumerated() {
            let style: UIAlertAction.Style = (index == options.count - 1) ? .cancel : .default
            
            let action = UIAlertAction(title: option, style: style) { _ in
                print("\(option) selected")
            }
            
            actionSheet.addAction(action)
        }
        
        // For iPad
        if let popoverController = actionSheet.popoverPresentationController {
            popoverController.sourceView = view
            popoverController.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(actionSheet, animated: true)
    }
    
    private func showDestructiveAlert() {
        let alert = UIAlertController(
            title: "Delete Item",
            message: "Are you sure you want to delete this item? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            print("Item deleted")
        })
        
        present(alert, animated: true)
    }
    
    private func showCustomAlert() {
        let alert = UIAlertController(
            title: "Custom Alert",
            message: "This is a custom alert with an image and custom actions.",
            preferredStyle: .alert
        )
        
        // Add image
        let imageView = UIImageView(image: UIImage(systemName: "star.fill"))
        imageView.tintColor = .systemYellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        alert.view.addSubview(imageView)
        
        // Layout constraints for the image
        let height = NSLayoutConstraint(
            item: alert.view!,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 220
        )
        
        let width = NSLayoutConstraint(
            item: alert.view!,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 270
        )
        
        alert.view.addConstraint(height)
        alert.view.addConstraint(width)
        
        let xConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: alert.view,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        )
        
        let yConstraint = NSLayoutConstraint(
            item: imageView,
            attribute: .centerY,
            relatedBy: .equal,
            toItem: alert.view,
            attribute: .centerY,
            multiplier: 0.7,
            constant: 0
        )
        
        let imageWidth = NSLayoutConstraint(
            item: imageView,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 60
        )
        
        let imageHeight = NSLayoutConstraint(
            item: imageView,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: 60
        )
        
        NSLayoutConstraint.activate([xConstraint, yConstraint, imageWidth, imageHeight])
        
        // Add actions
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension AlertExampleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = buttonTitles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(for: indexPath.row)
    }
}
