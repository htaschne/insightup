//
//  ViewController.swift
//  insightup
//
//  Created by Agatha Schneider on 12/05/25.
//

import UIKit

class HomeViewController: UIViewController {

    private var insights: [Insight] = []
    private var filteredInsights: [Insight] = []
    
    private lazy var buttonProfile: UIBarButtonItem = {
        UIBarButtonItem(
            image: UIImage(systemName: "person.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(profileButtonTapped)
        )
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        return searchController
    }()

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .green
        tableView.dataSource = self
        tableView.isHidden = true
        return tableView
    }()

    lazy var homeView: HomeScreenView = {
        guard let navigationController else { fatalError("Navigation controller not set") }
        var homeView = HomeScreenView(navigationController: navigationController)
        homeView.translatesAutoresizingMaskIntoConstraints = false
        homeView.isHidden = false
        homeView.backgroundColor = UIColor(named: "BackgroundsPrimary")
        homeView.addInsightButton.addTarget(self, action: #selector(modalButtonTapped), for: .touchUpInside)
        return homeView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Dismiss keyboard when tap outside it's area
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false  // allows table view cell taps to still register
        view.addGestureRecognizer(tapGesture)

        // appearence setup
        view.backgroundColor = UIColor(named: "BackgroundsPrimary")

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "InsightUp"
        navigationItem.backButtonTitle = "Back"
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = buttonProfile

        // search bar setup
        // TODO(Agatha): make this initialization better
        insights = InsightPersistence.getAll().insights
        filteredInsights = insights

        // view setup
        setup()
    }
    
    @objc func modalButtonTapped() {
        let modalVC = ModalAddInsightViewController()
        modalVC.modalPresentationStyle = .automatic
        
        modalVC.onDone = { [weak self] in
            guard let self = self else { return }
            
            self.insights = InsightPersistence.getAll().insights
            self.filteredInsights = self.insights
            self.tableView.reloadData()
            
            self.homeView.ideasButton.updateCounter()
            self.homeView.problemsButton.updateCounter()
            self.homeView.feelingsButton.updateCounter()
            self.homeView.observationsButton.updateCounter()
            self.homeView.allButton.updateCounter()
        }
        present(modalVC, animated: true)

    }
    
    @objc func profileButtonTapped() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }

}

extension HomeViewController: ViewCodeProtocol {
    func addSubviews() {
        [
            tableView,
            homeView,

        ].forEach(view.addSubview)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
                        
            homeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return filteredInsights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let insight = filteredInsights[indexPath.row]
        cell.textLabel?.text = insight.title
        cell.detailTextLabel?.text = insight.notes  // TODO(Agatha): make this conform to Figma
        return cell
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredInsights = insights
            tableView.reloadData()
            return
        }

        filteredInsights = insights.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }

        // Optional: use Levenshtein or fuzzy match here
        tableView.reloadData()
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO(Agatha): update
    }

}
