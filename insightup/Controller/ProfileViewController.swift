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
    
    private var onboardingData: OnboardingData?

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
        imgView.image = UIImage(named: "ProfileImage")
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
    
    private lazy var profileComponent: ProfileComponent = {
        var component = ProfileComponent()
        component.translatesAutoresizingMaskIntoConstraints = false
        return component
    }()

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    lazy var componentPreferences: PropertiesSelector = {
        var component = PropertiesSelector()
        guard let onboardingData = UserDefaults.standard.loadOnboarding() else { return component }
        component.translatesAutoresizingMaskIntoConstraints = false
        component.tableView.rowHeight = 44
        component.configure(with:[
            PropertyItem(
                    title: "Weekly Routine",
                    iconName: "calendar",
                    options: OnboardingData.WeeklyRoutine.allCases.map {$0.description},
                    selectedOptions: [onboardingData.routine?.description ?? ""],
                    multipleSelection: false
                ),
                PropertyItem(
                    title: "Areas of Interest",
                    iconName: "text.book.closed.fill",
                    options: OnboardingData.Interest.allCases.map { $0.description },
                    selectedOptions: onboardingData.interests.map { $0.description },
                    multipleSelection: true
                ),
                PropertyItem(
                    title: "Main Goals",
                    iconName: "checkmark.seal.fill",
                    options: OnboardingData.MainGoal.allCases.map { $0.description },
                    selectedOptions: onboardingData.mainGoals.map { $0.description },
                    multipleSelection: true
                )
        ], editable: true)
        return component
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let selectedRoutineDescription = componentPreferences.getValue(for: "Weekly Routine") ?? ""
        let selectedInterestsDescription = componentPreferences.getSelectedOptions(for: "Areas of Interest")
        let selectedGoalsDescription = componentPreferences.getSelectedOptions(for: "Main Goals")
        
        let selectedRoutine = OnboardingData.WeeklyRoutine.allCases.first { $0.rawValue == selectedRoutineDescription }
        var selectedInterests: [OnboardingData.Interest] = []
        var selectedGoals: [OnboardingData.MainGoal] = []
        
        for string in selectedInterestsDescription {
            if let interest = OnboardingData.Interest(rawValue: string) {
                selectedInterests.append(interest)
            }
        }
        for string in selectedGoalsDescription{
            if let goal = OnboardingData.MainGoal(rawValue: string) {
                selectedGoals.append(goal)
            }
        }
        
        guard var onboardingData = UserDefaults.standard.loadOnboarding() else {return}
        
        onboardingData.interests = selectedInterests
        onboardingData.mainGoals = selectedGoals
        onboardingData.routine = selectedRoutine
        
        print(selectedRoutineDescription)
        print(selectedInterestsDescription)
        print(selectedGoalsDescription)
        
        UserDefaults.standard.saveOnboarding(onboardingData)
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
    

}

extension ProfileViewController: ViewCodeProtocol {
    func addSubviews() {
        [
            //tableView,
            stackPreferences,
            profileComponent,
           // stackUserInfo,
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


                        
            profileComponent.topAnchor.constraint(equalTo: stackPreferences.bottomAnchor, constant: 16),
            profileComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profileComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            profileComponent.widthAnchor.constraint(equalToConstant: 370),
            profileComponent.heightAnchor.constraint(equalToConstant: 70),
            
            componentPreferences.topAnchor.constraint(equalTo: profileComponent.bottomAnchor, constant: 16),
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
