//
//  ViewController.swift
//  insightup
//
//  Created by Agatha Schneider on 12/05/25.
//

//dkjsadkaskdsalk

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {

    // MARK: - Properties
    private var insights: [Insight] = []
    private var filteredInsights: [Insight] = []
    private var homeView: HomeScreenView?
    
    // MARK: - UI Components
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupNotifications()
    }
    
    private func setupUI() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        view.backgroundColor = UIColor(named: "BackgroundsPrimary")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "InsightUp"
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = buttonProfile
        
        setupHomeView()
    }
    
    private func setupHomeView() {
        guard let navigationController = navigationController else {
            assertionFailure("HomeViewController must be embedded in a UINavigationController")
            return
        }
        
        let homeView = HomeScreenView(navigationController: navigationController)
        homeView.translatesAutoresizingMaskIntoConstraints = false
        homeView.backgroundColor = UIColor(named: "BackgroundsPrimary")
        self.homeView = homeView
        
        view.addSubview(homeView)
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupData() {
        insights = InsightPersistence.getAll().insights
        filteredInsights = insights
        homeView?.reloadData(with: filteredInsights)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateCategoryCounters),
            name: NSNotification.Name("InsightsDidChange"),
            object: nil
        )
    }

    // MARK: - Actions
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func modalButtonTapped() {
        let modalVC = ModalAddInsightViewController()
        modalVC.modalPresentationStyle = .automatic
        
        modalVC.onDone = { [weak self] _ in
            guard let self = self else { return }
            self.insights = InsightPersistence.getAll().insights
            self.filteredInsights = self.insights
            self.homeView?.reloadData(with: self.filteredInsights)
        }
        present(modalVC, animated: true)
    }

    @objc func profileButtonTapped() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }

    @objc func updateCategoryCounters() {
        homeView?.updateCategoryCounters()
    }
}

// MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        if searchText.isEmpty {
            filteredInsights = insights
        } else {
            filteredInsights = insights.filter { insight in
                insight.title.lowercased().contains(searchText) ||
                insight.notes.lowercased().contains(searchText)
            }
        }
        
        homeView?.reloadData(with: filteredInsights)
    }
}

// MARK: - UISearchControllerDelegate
extension HomeViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        UIView.setAnimationsEnabled(false)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        UIView.setAnimationsEnabled(true)
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        UIView.setAnimationsEnabled(false)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        UIView.setAnimationsEnabled(true)
    }
}
