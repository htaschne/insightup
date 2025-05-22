//
//  CategoryViewController.swift
//  insightup
//
//  Created by Enzo Tonatto on 13/05/25.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Constants
    private enum ReuseId {
        static let insight = "InsightCell"
    }

    // MARK: - Properties
    private var insights: [Insight] = []
    private var filteredInsights: [Insight] = []
    private var category: InsightCategory?
    
    // Cache for filter menu
    private lazy var filterActions: [InsightsFilter: UIAction] = {
        var actions: [InsightsFilter: UIAction] = [:]
        
        actions[.none] = UIAction(title: "None", state: .on) { [weak self] _ in 
            self?.applyFilter(.none) 
        }
        
        actions[.latestFirst] = UIAction(title: "Latest First", state: .off) { [weak self] _ in 
            self?.applyFilter(.latestFirst) 
        }
        
        actions[.oldestFirst] = UIAction(title: "Oldest First", state: .off) { [weak self] _ in 
            self?.applyFilter(.oldestFirst) 
        }
        
        actions[.highPriority] = UIAction(title: "High Priority", state: .off) { [weak self] _ in 
            self?.applyFilter(.highPriority) 
        }
        
        actions[.lowEffort] = UIAction(title: "Low Effort", state: .off) { [weak self] _ in 
            self?.applyFilter(.lowEffort) 
        }
        
        return actions
    }()
    
    private lazy var filterMenu: UIMenu = {
        return UIMenu(title: "", options: .displayInline, children: Array(filterActions.values))
    }()

    // MARK: - Components
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        return searchController
    }()

    private lazy var insightsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(InsightCell.self, forCellReuseIdentifier: InsightCell.reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = 8
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    @objc func handleAddInsight() {
        let vc = ModalAddInsightViewController(defaultCategory: category)
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = self
        present(vc, animated: true)
    }

    private lazy var addInsightButton: UIButton = {
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

    private lazy var emptyState: EmptyState = {
        var empty = EmptyState()
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.title = "No insights yet."
        empty.subtitle = "Add your thoughts, problems, or ideas to get started."
        return empty
    }()

    enum InsightsFilter {
        case none, latestFirst, oldestFirst, highPriority, lowEffort, biggestImpact
    }
    private var currentFilter: InsightsFilter = .none

    private lazy var filterButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease"),
            style: .plain,
            target: nil,
            action: nil
        )
        button.menu = filterMenu
        return button
    }()

    // MARK: - Filter Methods
    private func updateFilterMenuState() {
        // Turn off all actions
        filterActions.values.forEach { action in
            action.state = .off
        }
        
        // Turn on the current filter's action
        filterActions[currentFilter]?.state = .on
    }

    private func applyFilter(_ filter: InsightsFilter) {
        currentFilter = filter
        switch filter {
        case .none:
            filteredInsights = insights
        case .latestFirst:
            filteredInsights = insights.sorted { $0.createdAt > $1.createdAt }
        case .oldestFirst:
            filteredInsights = insights.sorted { $0.createdAt < $1.createdAt }
        case .highPriority:
            let priorityOrder: [Category] = [.High, .Medium, .Low, .None]
            filteredInsights = insights.sorted { insight1, insight2 in
                let index1 = priorityOrder.firstIndex(of: insight1.priority) ?? Int.max
                let index2 = priorityOrder.firstIndex(of: insight2.priority) ?? Int.max
                return index1 < index2
            }
        case .lowEffort:
            let effortOrder: [Effort] = [.Solo, .With1, .With2to4, .CrossTeam, .ExternalHelp]
            filteredInsights = insights.sorted { insight1, insight2 in
                let index1 = effortOrder.firstIndex(of: insight1.executionEffort) ?? Int.max
                let index2 = effortOrder.firstIndex(of: insight2.executionEffort) ?? Int.max
                return index1 < index2
            }
        case .biggestImpact:
            filteredInsights = insights // Removed from menu
        }
        
        updateFilterMenuState()
        insightsTableView.reloadData()
        updateEmptyStateVisibility()
    }

    // MARK: - Data Loading
    private func loadInsights() {
        guard let category else { return }
        let allInsights = InsightPersistence.getAllBy(category: category)
        insights = allInsights
        applyFilter(currentFilter) // Reapply current filter instead of resetting
    }

    // MARK: - TableView Methods
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredInsights.count
    }

    @objc func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: InsightCell.reuseIdentifier,
            for: indexPath
        ) as? InsightCell else {
            return UITableViewCell()
        }
        let insight = filteredInsights[indexPath.row]
        // Exibir apenas o título, sem ícone de prioridade ou data
        cell.textLabel?.text = insight.title
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.textLabel?.numberOfLines = 1
        cell.detailTextLabel?.text = nil
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // Swipe to delete
    @objc func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let insightToDelete = filteredInsights[indexPath.row]
            // Remove do array principal
            if let idx = insights.firstIndex(where: { $0.id == insightToDelete.id }) {
                insights.remove(at: idx)
            }
            // Remove do array filtrado
            filteredInsights.remove(at: indexPath.row)
            // Remove da persistência
            var all = InsightPersistence.getAll()
            if let idx = all.insights.firstIndex(where: { $0.id == insightToDelete.id }) {
                all.insights.remove(at: idx)
                InsightPersistence.save(insights: all)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateEmptyStateVisibility()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedInsight = filteredInsights[indexPath.row]
        let detailVC = InsightDetailViewController(insight: selectedInsight)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - Layout
    func addConstraints() {
        NSLayoutConstraint.activate([
            emptyState.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 98
            ),
            emptyState.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -98
            ),
            emptyState.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyState.heightAnchor.constraint(equalToConstant: 120),

            insightsTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            insightsTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            insightsTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            insightsTableView.bottomAnchor.constraint(
                equalTo: addInsightButton.topAnchor,
                constant: -16
            ),

            addInsightButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            addInsightButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            addInsightButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            addInsightButton.heightAnchor.constraint(equalToConstant: 48),
        ])
    }

    // MARK: Initialization
    init(category: InsightCategory) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        view.backgroundColor = UIColor(named: "BackgroundsPrimary")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = category?.rawValue
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = filterButton

        loadInsights()
        updateEmptyStateVisibility()

        // MARK: Custominzação da navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "BackgroundsPrimary")

        guard let category else { return }
        appearance.titleTextAttributes = [
            .foregroundColor: category.color
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: category.color
        ]

        navigationItem.standardAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }

    private func updateEmptyStateVisibility() {
        let isEmpty = filteredInsights.isEmpty
        emptyState.isHidden = !isEmpty
        insightsTableView.isHidden = isEmpty
    }
}

// MARK: Protocols
extension CategoryViewController: UISearchResultsUpdating, UISearchBarDelegate {

    @objc func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        if text.isEmpty {
            filteredInsights = insights
        } else {
            filteredInsights = insights.filter {
                $0.title.localizedCaseInsensitiveContains(text)
            }
        }
        updateEmptyStateVisibility()
        insightsTableView.reloadData()
    }

    @objc func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        updateSearchResults(for: searchController)
    }
}

extension CategoryViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(emptyState)
        view.addSubview(insightsTableView)
        view.addSubview(addInsightButton)
    }


}

extension CategoryViewController: ModalAddInsightDelegate {
    func didAddInsight(_ insight: Insight) {
        loadInsights()
    }
    func didUpdateInsight(_ insight: Insight) {
        loadInsights()
    }
}
