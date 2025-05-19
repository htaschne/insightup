//
//  HomeScreenView.swift
//  insightup
//
//  Created by Agatha Schneider on 13/05/25.
//

import UIKit

class HomeScreenView: UIView {
    
    private var topInsights: [Insight] = []

    var navigationController: UINavigationController?
    
    private func loadTopInsights() {
        let allInsights = InsightPersistence.getAll().insights

        let priorityOrder: [Category] = [.High, .Medium, .Low, .None]
        let sortedInsights = allInsights.sorted {
            guard let firstIndex = priorityOrder.firstIndex(of: $0.priority),
                  let secondIndex = priorityOrder.firstIndex(of: $1.priority) else {
                return false
            }
            return firstIndex < secondIndex
        }

        topInsights = Array(sortedInsights.prefix(3))
        highPriorityTableView.isHidden = topInsights.isEmpty
        priorityLabel.isHidden = topInsights.isEmpty
        highPriorityTableView.reloadData()
    }

    init(navigationController: UINavigationController) {
        super.init(frame: .zero)
        self.navigationController = navigationController
        setup()
        loadTopInsights()
    }
    
    @objc func handleIdeasButton() {
        let vc = CategoryViewController(category: .Ideas)
        guard let navigationController else { fatalError("Could not unwrap navigationController") }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var ideasButton: CardCategoryComponent = {
        let card = CardCategoryComponent(category: .Ideas)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleIdeasButton))
        card.addGestureRecognizer(tap)
        return card
    }()
    
    @objc func handleProblemsButton() {
        let vc = CategoryViewController(category: .Problems)
        guard let navigationController else { fatalError("Could not unwrap navigationController") }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var problemsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Problems)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProblemsButton))
        card.addGestureRecognizer(tap)
        return card
    }()
    
    @objc func handleFeelingsButton() {
        let vc = CategoryViewController(category: .Feelings)
        guard let navigationController else { fatalError("Could not unwrap navigationController") }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var feelingsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Feelings)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFeelingsButton))
        card.addGestureRecognizer(tap)
        return card
    }()
    
    @objc func handleObservationButton() {
        let vc = CategoryViewController(category: .Observations)
        guard let navigationController else { fatalError("Could not unwrap navigationController") }
        navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var observationsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Observations)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleObservationButton))
        card.translatesAutoresizingMaskIntoConstraints = false
        card.addGestureRecognizer(tap)
        return card
    }()

    @objc func handleAllButton() {
        let vc = CategoryViewController(category: .All)
        guard let navigationController else { fatalError("Could not unwrap navigationController") }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var allButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .All)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAllButton))
        card.addGestureRecognizer(tap)
        return card
    }()

    lazy var topButtonsStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [
            ideasButton, problemsButton,
        ])
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var bottomButtonsStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [
            feelingsButton, observationsButton,
        ])
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var buttons: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [
            topButtonsStackView,
            bottomButtonsStackView,
            allButton,
        ])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var priorityLabel: UILabel = {
        var label = UILabel()
        label.text = "High Priority"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var highPriorityTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 44
        tableView.register(HighPriorityInsightCell.self, forCellReuseIdentifier: HighPriorityInsightCell.reuseIdentifier)
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    lazy var addInsightButton: UIButton = {
        var button = UIButton()
        button.setTitle("Add Insight", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        loadTopInsights()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        loadTopInsights()
    }

}

extension HomeScreenView: ViewCodeProtocol {
    func addSubviews() {
        [
            buttons,
            priorityLabel,
            highPriorityTableView,
            addInsightButton,

        ].forEach({ addSubview($0) })
    }

    func addConstraints() {
        ideasButton.heightAnchor.constraint(equalToConstant: 81).isActive = true
        problemsButton.heightAnchor.constraint(equalToConstant: 81).isActive = true
        feelingsButton.heightAnchor.constraint(equalToConstant: 81).isActive = true
        observationsButton.heightAnchor.constraint(equalToConstant: 81).isActive = true
        allButton.heightAnchor.constraint(equalToConstant: 81).isActive = true

        NSLayoutConstraint.activate([
            buttons.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            buttons.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            buttons.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),

            priorityLabel.topAnchor.constraint(
                equalTo: buttons.bottomAnchor,
                constant: 16
            ),
            priorityLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            priorityLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            highPriorityTableView.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: 8),
            highPriorityTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            highPriorityTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            highPriorityTableView.bottomAnchor.constraint(equalTo: addInsightButton.topAnchor, constant: -70),


            addInsightButton.heightAnchor.constraint(equalToConstant: 50),
            addInsightButton.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -57
            ),
            addInsightButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            addInsightButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
        ])
    }

}

extension HomeScreenView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HighPriorityInsightCell.reuseIdentifier, for: indexPath) as? HighPriorityInsightCell else {
            return UITableViewCell()
        }
        cell.configure(with: topInsights[indexPath.row])
        return cell
    }
}
