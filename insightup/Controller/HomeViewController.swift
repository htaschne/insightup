//
//  ViewController.swift
//  insightup
//
//  Created by Agatha Schneider on 12/05/25.
//

import DesignSystem
import UIKit

class HomeViewController: UIViewController {

    private var insights: [Insight] = []
    private var filteredInsights: [Insight] = []

    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barStyle = .default
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal // removes background and line
        searchBar.backgroundImage = UIImage() // remove default shadow image
        return searchBar
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss keyboard when tap outside it's area
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // allows table view cell taps to still register
        view.addGestureRecognizer(tapGesture)

        // appearence setup
        view.backgroundColor = .white
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .white // match your desired nav bar color
            appearance.shadowColor = .clear // this removes the line

            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
            navigationBar.prefersLargeTitles = true
        }
        navigationItem.title = "InsightUp"
        
        // search bar setup
        // TODO(Agatha): make this initialization better
        insights = InsightPersistence.getAll().insights
        filteredInsights = insights
        searchBar.delegate = self
        
        // view setup
        setup()
    }

}


extension HomeViewController: ViewCodeProtocol {
    func addSubviews() {
        [
            searchBar,
            tableView
        ].forEach(view.addSubview)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredInsights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let insight = filteredInsights[indexPath.row]
        cell.textLabel?.text = insight.title
        cell.detailTextLabel?.text = insight.notes // TODO(Agatha): make this conform to Figma
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

