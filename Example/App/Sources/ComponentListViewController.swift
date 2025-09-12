import UIKit

class ComponentListViewController: UIViewController {
    
    // MARK: - Properties
    
    private let components: [ComponentExample] = [
        ComponentExample(name: "Buttons", description: "Various button styles", type: .button),
        ComponentExample(name: "Cards", description: "Card components with different layouts", type: .card),
        ComponentExample(name: "Alerts", description: "Alert and action sheet examples", type: .alert),
        ComponentExample(name: "Text Fields", description: "Input field variations", type: .textField),
        ComponentExample(name: "Loaders", description: "Loading indicators", type: .loader)
    ]
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(ComponentCell.self, forCellReuseIdentifier: "ComponentCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        title = "Component System"
        view.backgroundColor = .systemGroupedBackground
        
        // Configure table view
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Layout constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension ComponentListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComponentCell", for: indexPath) as! ComponentCell
        let component = components[indexPath.row]
        cell.configure(with: component)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let component = components[indexPath.row]
        var viewController: UIViewController
        
        switch component.type {
        case .button:
            viewController = ButtonExampleViewController()
        case .card:
            viewController = CardExampleViewController()
        case .alert:
            viewController = AlertExampleViewController()
        case .textField:
            viewController = TextFieldExampleViewController()
        case .loader:
            viewController = LoaderExampleViewController()
        }
        
        viewController.title = component.name
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - ComponentCell

private class ComponentCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with component: ComponentExample) {
        nameLabel.text = component.name
        descriptionLabel.text = component.description
    }
}

// MARK: - Models

private struct ComponentExample {
    let name: String
    let description: String
    let type: ComponentType
}

private enum ComponentType {
    case button
    case card
    case alert
    case textField
    case loader
}
