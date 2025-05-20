//
//  ViewController.swift
//  insightup
//
//  Created by Agatha Schneider on 12/05/25.
//

//dkjsadkaskdsalk

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {

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

    lazy var homeView: HomeScreenView = {
        guard let navigationController else { fatalError("Navigation controller not set") }
        let homeView = HomeScreenView(navigationController: navigationController)
        homeView.translatesAutoresizingMaskIntoConstraints = false
        homeView.isHidden = false
        homeView.backgroundColor = UIColor(named: "BackgroundsPrimary")
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

        insights = InsightPersistence.getAll().insights
        filteredInsights = insights

        setup()
        searchController.delegate = self
    }
    
    @objc func modalButtonTapped() {
        let modalVC = ModalAddInsightViewController()
        modalVC.modalPresentationStyle = .automatic
        
        modalVC.onDone = { [weak self] _ in
            guard let self = self else { return }
            
            self.insights = InsightPersistence.getAll().insights
            self.filteredInsights = self.insights
            
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

    // override func viewDidAppear(_ animated: Bool) {
    //     super.viewDidAppear(animated)
    //     // MOCK: Apresenta a tela de detalhes de um Insight para teste visual
    //     let mockInsight = Insight(
    //         title: "Polls in stories get the most replies",
    //         notes: "Interactive content significantly boosts user engagement compared to traditional static posts. It encourages participation and fosters a deeper connection with the audience, making the experience more dynamic and enjoyable.",
    //         category: .Observations,
    //         priority: Category.Low,
    //         audience: TargetAudience.B2B,
    //         executionEffort: Effort.Solo,
    //         budget: Budget.LessThan100
    //     )
    //     let detailVC = InsightDetailViewController(insight: mockInsight)
    //     let nav = UINavigationController(rootViewController: detailVC)
    //     nav.modalPresentationStyle = UIModalPresentationStyle.fullScreen
    //     self.present(nav, animated: true)
    // }
}

extension HomeViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(homeView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

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
    }
}

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
