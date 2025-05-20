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
        homeView.backgroundColor = UIColor(named: "BackgroundsSecondary")
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

        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "InsightUp"
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = buttonProfile

        // Adiciona o botão de perfil customizado na navigation bar
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "person.circle.fill"), for: .normal)
        button.tintColor = .systemGray
        button.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton

        // search bar setup
        // TODO(Agatha): make this initialization better
        insights = InsightPersistence.getAll().insights
        filteredInsights = insights

        // view setup
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
            self.tableView.reloadData()
            
            self.homeView.ideasButton.updateCounter()
            self.homeView.problemsButton.updateCounter()
            self.homeView.feelingsButton.updateCounter()
            self.homeView.observationsButton.updateCounter()
            self.homeView.allButton.updateCounter()
        }
        present(modalVC, animated: true)
    }

    @objc func profileTapped() {
        // ação do perfil
        print("Perfil clicado!")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // MOCK: Apresenta a tela de detalhes de um Insight para teste visual
        let mockInsight = Insight(
            title: "Polls in stories get the most replies",
            notes: "Interactive content significantly boosts user engagement compared to traditional static posts. It encourages participation and fosters a deeper connection with the audience, making the experience more dynamic and enjoyable.",
            category: .Observations,
            priority: Category.Low,
            audience: TargetAudience.B2B,
            executionEffort: Effort.Solo,
            budget: Budget.LessThan100
        )
        let detailVC = InsightDetailViewController(insight: mockInsight)
        let nav = UINavigationController(rootViewController: detailVC)
        nav.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(nav, animated: true)
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


extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO(Agatha): update
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
