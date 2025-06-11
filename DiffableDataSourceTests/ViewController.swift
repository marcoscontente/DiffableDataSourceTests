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
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.dataSource = dataSource
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()

    private var dataSource: UITableViewDiffableDataSource<Section, Item>!

    private class DataSource: UITableViewDiffableDataSource<Section, Item> {
        override func tableView(_ tableView: UITableView, titleForHeaderInSection sectionIndex: Int) -> String? {
            let section = snapshot().sectionIdentifiers[sectionIndex]
            return section.title
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)

        dataSource = DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = item.name
            return cell
        }

        applySnapshot()
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        let countsBySection: [Section: Int] = allItems.reduce(into: [:]) { dict, item in
            dict[item.category, default: 0] += 1
        }

        let sortedSections = Section.allCases.sorted { lhs, rhs in
            countsBySection[lhs, default: 0] > countsBySection[rhs, default: 0]
        }

        snapshot.appendSections(sortedSections)

        for section in sortedSections {
            let itemsInSection = allItems.filter { $0.category == section }
            snapshot.appendItems(itemsInSection, toSection: section)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
