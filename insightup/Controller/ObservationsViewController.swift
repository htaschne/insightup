//
//  ObservationsViewController.swift
//  insightup
//
//  Created by Enzo Tonatto on 13/05/25.
//

import UIKit

class ObservationsViewController: UIViewController {
    
    private var insights: [String] = []
    
    private var filteredInsights: [String] = []
    
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ObservationCell")
        tableView.rowHeight = 44
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = 8
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var addInsightButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add insight", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.layer.cornerRadius = 8
        button.backgroundColor = .colorsBlue
        return button
    }()
    
    private lazy var emptyState: EmptyState = {
        var empty = EmptyState()
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.title = "No insights yet."
        empty.subtitle = "Add your thoughts, problems, or ideas to get started."
        return empty
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        view.backgroundColor = .backgroundsGroupedPrimary
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Observations"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        filteredInsights = insights
        updateEmptyStateVisibility()

        
        // MARK: Custominzação da navigation bar
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .backgroundsTertiary
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.colorsGreen
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.colorsGreen
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

extension ObservationsViewController: UISearchResultsUpdating, UISearchBarDelegate {

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
    }

    @objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResults(for: searchController)
    }
}

extension ObservationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredInsights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ObservationCell", for: indexPath)
    cell.textLabel?.text = filteredInsights[indexPath.row]
    return cell
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Tapped:", filteredInsights[indexPath.row])
    }
}

extension ObservationsViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(emptyState)
        view.addSubview(insightsTableView)
        view.addSubview(addInsightButton)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            emptyState.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 98),
            emptyState.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -98),
            emptyState.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyState.heightAnchor.constraint(equalToConstant: 120),
            
            insightsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            insightsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            insightsTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            insightsTableView.bottomAnchor.constraint(equalTo: addInsightButton.topAnchor, constant: -8),
            
            addInsightButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addInsightButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addInsightButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addInsightButton.heightAnchor.constraint(equalToConstant: 48),

        ])
    }
    
    
}
