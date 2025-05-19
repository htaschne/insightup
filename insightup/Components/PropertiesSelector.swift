//
//  CategoryTemplate.swift
//  insightup
//
//  Created by aluno-02 on 13/05/25.
//

//import DesignSystem
import UIKit

class PropertiesSelector: UIView {
    
    private var items: [PropertyItem] = []

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(SelectorCell.self, forCellReuseIdentifier: SelectorCell.reuseIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.layer.cornerRadius = 12
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with items: [PropertyItem]) {
        self.items = items
        self.layer.cornerRadius = 12

        tableView.reloadData()
    }
    
    func getValue(for title: String) -> String? {
        for i in 0..<items.count {
            if items[i].title == title,
               let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? SelectorCell {
                return cell.btnCategory.configuration?.title
            }
        }
        return nil
    }


}


extension PropertiesSelector: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SelectorCell.reuseIdentifier,
            for: indexPath
        ) as? SelectorCell else {
            return UITableViewCell()
        }

        let item = items[indexPath.row]
        cell.configure(title: item.title, iconName: item.iconName, options: item.options)
        return cell
    }
}


extension PropertiesSelector: ViewCodeProtocol {
    func addSubviews() {
        addSubview(tableView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}



