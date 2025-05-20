//
//  ViewController.swift
//  insightup
//
//  Created by Agatha Schneider on 12/05/25.
//

import UIKit

class ProfileViewController: UIViewController {

    private var insights: [Insight] = []
    private var filteredInsights: [Insight] = []

    private lazy var labelPreferencesTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Your Preferences"
        label.textColor = UIColor(named: "LabelsPrimary")
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    private lazy var labelPreferencesFooter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Used by InsightUp’s AI to adapt suggestions and reminders to your style."
        label.numberOfLines = 3
        label.textColor = UIColor(named: "LabelsSecondary")
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var stackPreferences: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelPreferencesTitle, labelPreferencesFooter])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    private lazy var imgProfilePicture: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(systemName: "person.circle.fill")
        imgView.tintColor = .systemGray
        return imgView
    }()
    
    private lazy var labelUserName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Leonardo Simon Monteiro"
        label.textColor = UIColor(named: "LabelsPrimary")
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var labelUserFooter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Apple Account, iCloud+, and more"
        label.numberOfLines = 3
        label.textColor = UIColor(named: "LabelsSecondary")
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    
    
    private lazy var stackUserName: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelUserName, labelUserFooter])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    private lazy var stackUserInfo: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [imgProfilePicture, stackUserName])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        stack.backgroundColor = UIColor(named: "BackgroundsTertiary")
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        stack.layer.cornerRadius = 12
        return stack
    }()

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    lazy var componentPreferences: PropertiesSelector = {
        var component = PropertiesSelector()
        component.translatesAutoresizingMaskIntoConstraints = false
        component.tableView.rowHeight = 44
        component.configure(with:[
            PropertyItem(
                    title: "Weekly Routine",
                    iconName: "calendar",
                    options: OnboardingData.WeeklyRoutine.allCases.map {$0.description}
                ),
                PropertyItem(
                    title: "Areas of Interest",
                    iconName: "text.book.closed.fill",
                    options: OnboardingData.Interest.allCases.map { $0.description }
                ),
                PropertyItem(
                    title: "Main Goal",
                    iconName: "checkmark.seal.fill",
                    options: OnboardingData.MainGoal.allCases.map { $0.description }
                )
        ])
        return component
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
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
        view.backgroundColor = UIColor(named: "BackgroundsGroupedPrimary")

        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Profile"
        navigationItem.backButtonTitle = "Back"
        navigationController?.navigationBar.backgroundColor = UIColor(named: "BackgroundsTertiary")
        
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
           // appearance.backgroundColor = .white // mesma cor da sua view
           // appearance.titleTextAttributes = [.foregroundColor: UIColor.black]

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance

        // search bar setup
        // TODO(Agatha): make this initialization better

        // view setup
        setup()
    }
    
    @objc func modalButtonTapped() {
        let modalVC = ModalAddInsightViewController()
        modalVC.modalPresentationStyle = .automatic
        present(modalVC, animated: true)

    }

}

extension ProfileViewController: ViewCodeProtocol {
    func addSubviews() {
        [
            //tableView,
            stackPreferences,
            stackUserInfo,
            componentPreferences

        ].forEach(view.addSubview)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            
            stackPreferences.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackPreferences.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stackPreferences.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
          //  stackPreferences.heightAnchor.constraint(equalToConstant: 200),
            stackPreferences.widthAnchor.constraint(equalToConstant: 184),
            
            imgProfilePicture.heightAnchor.constraint(equalToConstant: 54),
            imgProfilePicture.widthAnchor.constraint(equalToConstant: 54),


                        
            stackUserInfo.topAnchor.constraint(equalTo: stackPreferences.bottomAnchor, constant: 16),
            stackUserInfo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackUserInfo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackUserInfo.widthAnchor.constraint(equalToConstant: 370),            stackUserInfo.heightAnchor.constraint(equalToConstant: 70),
            
            componentPreferences.topAnchor.constraint(equalTo: stackUserInfo.bottomAnchor, constant: 16),
            componentPreferences.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            componentPreferences.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            componentPreferences.heightAnchor.constraint(equalToConstant: 132),
            componentPreferences.widthAnchor.constraint(equalToConstant: 370),
           // stackUserName.heightAnchor.constraint(equalToConstant: 20),

            //stackUserName.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProfileViewController: UITableViewDataSource {
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


extension ProfileViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // TODO(Agatha): update
    }

}
