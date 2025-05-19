//
//  CategoryTemplate.swift
//  insightup
//
//  Created by aluno-02 on 13/05/25.
//

//import DesignSystem
import UIKit

protocol PropertiesSelectorDelegate: AnyObject {
    func propertiesSelector(_ selector: PropertiesSelector, didSelectItemAt indexPath: IndexPath)
}

class PropertiesSelector: UIView {
    
    private var items: [PropertyItem] = []
    weak var delegate: PropertiesSelectorDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SelectorCell.self, forCellReuseIdentifier: SelectorCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 12
        tableView.rowHeight = 51
        tableView.backgroundColor = .clear
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        addSubviews()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        addSubviews()
        addConstraints()
    }

    func configure(with items: [PropertyItem]) {
        self.items = items
        self.layer.cornerRadius = 12
        tableView.reloadData()
        let totalHeight = CGFloat(items.count) * tableView.rowHeight
        self.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
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
        if indexPath.row < items.count - 1 {
            if cell.contentView.viewWithTag(999) == nil {
                let divider = UIView()
                divider.backgroundColor = UIColor.systemGray5
                divider.translatesAutoresizingMaskIntoConstraints = false
                divider.tag = 999
                cell.contentView.addSubview(divider)
                NSLayoutConstraint.activate([
                    divider.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 56),
                    divider.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
                    divider.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                    divider.heightAnchor.constraint(equalToConstant: 1)
                ])
            }
        } else {
            cell.contentView.viewWithTag(999)?.removeFromSuperview()
        }
        return cell
    }
}

extension PropertiesSelector: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.propertiesSelector(self, didSelectItemAt: indexPath)
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



