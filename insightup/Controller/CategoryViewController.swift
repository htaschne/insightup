//
//  CategoryViewController.swift
//  insightup
//
//  Created by Enzo Tonatto on 13/05/25.
//

import UIKit

class CategoryViewController: UIViewController {

    // MARK: Variables
    private var insights: [String] = []
    private var filteredInsights: [String] = []
    private var tableViewHeightConstraint: NSLayoutConstraint?

    var category: InsightCategory?
    init(category: InsightCategory) {
        super.init(nibName: nil, bundle: nil)
        self.category = category
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Components
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
        tableView.rowHeight = 44
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = 8
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()

    @objc func handleAddInsight() {
        let vc = ModalAddInsightViewController()
        vc.modalPresentationStyle = .pageSheet
        vc.delegate = self
        vc.navBar.backItem?.title = "Back"
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

    private lazy var filterButton: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease"),
            style: .plain,
            target: self,
            action: #selector(handleFilter)
        )
    }()

    private func loadInsights() {
        guard let category else { return }
        let allInsights = InsightPersistence.getAllBy(category: category)

        insights = allInsights.map { $0.title }
        filteredInsights = insights
        insightsTableView.reloadData()
        updateEmptyStateVisibility()
        updateTableViewHeight()
    }

    // MARK: Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        view.backgroundColor = UIColor(named: "BackgroundsSecondary")
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

    @objc private func handleFilter() {
        print("Filter pressed")
        // TODO
    }

    private func updateEmptyStateVisibility() {
        let isEmpty = filteredInsights.isEmpty
        emptyState.isHidden = !isEmpty
        insightsTableView.isHidden = isEmpty
    }
    
    private func updateTableViewHeight() {
        insightsTableView.layoutIfNeeded()
        tableViewHeightConstraint?.constant = insightsTableView.contentSize.height
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
                $0.localizedCaseInsensitiveContains(text)
            }
        }
        updateEmptyStateVisibility()
        insightsTableView.reloadData()
        updateTableViewHeight()
    }

    @objc func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {
        updateSearchResults(for: searchController)
    }
}

extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return filteredInsights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: InsightCell.reuseIdentifier,
            for: indexPath
        ) as? InsightCell else {
            return UITableViewCell()
        }

        let title = filteredInsights[indexPath.row]
        let isLast = indexPath.row == filteredInsights.count - 1
        cell.configure(with: title, isLast: isLast)
        return cell
    }


    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped:", filteredInsights[indexPath.row])
    }
}

extension CategoryViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(emptyState)
        view.addSubview(insightsTableView)
        view.addSubview(addInsightButton)
    }

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
            
            addInsightButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            addInsightButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),
            addInsightButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: -50
            ),
            addInsightButton.heightAnchor.constraint(equalToConstant: 48),

        ])
        
        tableViewHeightConstraint = insightsTableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightConstraint?.isActive = true
        
    }

}

extension CategoryViewController: ModalAddInsightDelegate {
    func didAddInsight() {
        loadInsights()  // ✅ refresh the table
    }
}
