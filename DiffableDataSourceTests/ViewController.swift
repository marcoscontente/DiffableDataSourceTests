//
//  ViewController.swift
//  DiffableDataSourceTests
//
//  Created by Marcos Contente on 10/06/25.
//

import UIKit

enum Section: Int, CaseIterable {
    case fruits, vegetables

    var title: String {
        switch self {
        case .fruits:
            return "Fruits"
        case .vegetables:
            return "Vegeatables"
        }
    }
}

struct Item: Hashable {
    let id = UUID()
    let name: String
    let category: Section
}

class ViewController: UIViewController {
    private let allItems: [Item] = [
        Item(name: "Apple", category: .fruits),
        Item(name: "Banana", category: .fruits),
        Item(name: "Orange", category: .fruits),
        Item(name: "Carrot", category: .vegetables),
        Item(name: "Green Peas", category: .vegetables)
    ]

    private lazy var tableView: UITableView = {
        UITableView(frame: view.bounds)
    }()

    private var dataSource: UITableViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        dataSource = UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item.name
            return cell
        }

        tableView.dataSource = dataSource

        applySnapshot()
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)

        snapshot.appendItems(allItems)

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
