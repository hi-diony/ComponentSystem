//
//  ComponentListViewController.swift
//  ComponentSystem
//
//  Created by Station3 on 9/12/25.
//

import UIKit
import PinLayout
import FlexLayout
import ComponentSystem

final class ComponentListViewController: UIViewController {
    fileprivate typealias DataSource = UITableViewDiffableDataSource<OnlySection, ComponentType>
    fileprivate typealias Snapshot = NSDiffableDataSourceSnapshot<OnlySection, ComponentType>

    private lazy var dataSource: DataSource = initDataSource()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupLayout()
        
        updateData()
    }
    
    private func setupUI() {
        title = "Component System"
        
        view.backgroundColor = .systemGroupedBackground
        tableView.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
    }
    
    private func updateData() {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(ComponentType.allCases)
        dataSource.apply(snapshot)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.pin.all()
    }
}

extension ComponentListViewController: UITableViewDelegate {
    private func initDataSource() -> DataSource {
        return DataSource(tableView: tableView) { [weak self] tableView, indexPath, identifier -> UITableViewCell? in
            guard let self = self else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.selectionStyle = .none
            
            var content = cell.defaultContentConfiguration()
            content.text = identifier.title
            cell.contentConfiguration = content
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let component = dataSource.itemIdentifier(for: indexPath)
        
        switch component {
        case .toast:
            let vc = ToastExampleViewController()
            navigationController?.pushViewController(vc, animated: true)
//        case .card:
//            viewController = CardExampleViewController()
//        case .alert:
//            viewController = AlertExampleViewController()
//        case .textField:
//            viewController = TextFieldExampleViewController()
//        case .loader:
//            viewController = LoaderExampleViewController()
        case .none:
            break
        }
    }
}

