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
                let secondIndex = priorityOrder.firstIndex(of: $1.priority)
            else {
                return false
            }
            return firstIndex < secondIndex
        }

        topInsights = Array(sortedInsights.prefix(3))
        highPriorityTableView.isHidden = topInsights.isEmpty
        priorityLabel.isHidden = topInsights.isEmpty
        highPriorityTableView.reloadData()
        updateCategoryCounters()
    }

    init(navigationController: UINavigationController) {
        super.init(frame: .zero)
        self.navigationController = navigationController
        setup()
        loadTopInsights()
    }

    @objc func handleIdeasButton() {
        let vc = CategoryViewController(category: .Ideas)
        guard let navigationController else {
            fatalError("Could not unwrap navigationController")
        }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var ideasButton: CardCategoryComponent = {
        let card = CardCategoryComponent(category: .Ideas)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleIdeasButton)
        )
        card.addGestureRecognizer(tap)
        return card
    }()

    @objc func handleProblemsButton() {
        let vc = CategoryViewController(category: .Problems)
        guard let navigationController else {
            fatalError("Could not unwrap navigationController")
        }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var problemsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Problems)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleProblemsButton)
        )
        card.addGestureRecognizer(tap)
        return card
    }()

    @objc func handleFeelingsButton() {
        let vc = CategoryViewController(category: .Feelings)
        guard let navigationController else {
            fatalError("Could not unwrap navigationController")
        }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var feelingsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Feelings)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleFeelingsButton)
        )
        card.addGestureRecognizer(tap)
        return card
    }()

    @objc func handleObservationButton() {
        let vc = CategoryViewController(category: .Observations)
        guard let navigationController else {
            fatalError("Could not unwrap navigationController")
        }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var observationsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Observations)
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleObservationButton)
        )
        card.translatesAutoresizingMaskIntoConstraints = false
        card.addGestureRecognizer(tap)
        return card
    }()

    @objc func handleAllButton() {
        let vc = CategoryViewController(category: .All)
        guard let navigationController else {
            fatalError("Could not unwrap navigationController")
        }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var allButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .All)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleAllButton)
        )
        card.addGestureRecognizer(tap)
        return card
    }()

    // Grid 2x2 para os cards de categoria
    lazy var topButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ideasButton, problemsButton])
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var bottomButtonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [feelingsButton, observationsButton])
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var buttons: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            topButtonsStackView,
            bottomButtonsStackView
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
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 56
        tableView.register(
            HighPriorityInsightCell.self,
            forCellReuseIdentifier: HighPriorityInsightCell.reuseIdentifier
        )
        tableView.layer.cornerRadius = 16
        tableView.clipsToBounds = true
        tableView.backgroundColor = UIColor(named: "BackgroundsTertiary")
        tableView.separatorStyle = .none
        return tableView
    }()

    @objc func handleAddInsight() {
        let vc = ModalAddInsightViewController()
        vc.modalPresentationStyle = .pageSheet
        navigationController?.present(vc, animated: true)
    }

    lazy var addInsightButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Add Insight"
        config.image = UIImage(systemName: "plus")
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.contentInsets = .init(
            top: 14,
            leading: 16,
            bottom: 14,
            trailing: 16
        )
        config.baseBackgroundColor = .colorsBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .medium

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.layer.cornerRadius = 8
        button.addTarget(
            self,
            action: #selector(handleAddInsight),
            for: .touchUpInside
        )

        return button
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        loadTopInsights()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "BackgroundsSecondary")
        setup()
        loadTopInsights()
    }

    func setup() {
        addSubview(buttons)
        addSubview(allButton)
        addSubview(priorityLabel)
        addSubview(highPriorityTableView)
        addSubview(addInsightButton)

        ideasButton.heightAnchor.constraint(equalToConstant: 81).isActive = true;
        problemsButton.heightAnchor.constraint(equalToConstant: 81).isActive = true;
        feelingsButton.heightAnchor.constraint(equalToConstant: 81).isActive = true;
        observationsButton.heightAnchor.constraint(equalToConstant: 81).isActive = true;
        allButton.heightAnchor.constraint(equalToConstant: 81).isActive = true;

        NSLayoutConstraint.activate([
            buttons.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            buttons.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttons.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            allButton.topAnchor.constraint(equalTo: buttons.bottomAnchor, constant: 15),
            allButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            allButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            allButton.heightAnchor.constraint(equalToConstant: 81),

            priorityLabel.topAnchor.constraint(equalTo: allButton.bottomAnchor, constant: 24),
            priorityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            priorityLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            highPriorityTableView.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: 8),
            highPriorityTableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            highPriorityTableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            highPriorityTableView.heightAnchor.constraint(equalToConstant: (56 * 3)),

            addInsightButton.topAnchor.constraint(equalTo: highPriorityTableView.bottomAnchor, constant: 16),
            addInsightButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addInsightButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addInsightButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    public func updateCategoryCounters() {
        ideasButton.updateCounter()
        problemsButton.updateCounter()
        feelingsButton.updateCounter()
        observationsButton.updateCounter()
        allButton.updateCounter()
    }

}

extension HomeScreenView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return topInsights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HighPriorityInsightCell.reuseIdentifier,
                for: indexPath
            ) as? HighPriorityInsightCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: topInsights[indexPath.row])
        return cell
    }
}

extension HomeScreenView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedInsight = topInsights[indexPath.row]
        let detailVC = InsightDetailViewController(insight: selectedInsight)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
