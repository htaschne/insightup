//
//  HomeScreenView.swift
//  insightup
//
//  Created by Agatha Schneider on 13/05/25.
//

import UIKit

class HomeScreenView: UIView {

    var navigationController: UINavigationController?

    init(navigationController: UINavigationController) {
        super.init(frame: .zero)
        self.navigationController = navigationController
        setup()
    }

    lazy var ideasButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemYellow
        button.setTitle("Ideas", for: .normal)
        return button
    }()

    lazy var problemsButton: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.setTitle("Problems", for: .normal)
        return button
    }()

    lazy var topButtonsStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [
            ideasButton, problemsButton,
        ])
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var feelingsButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.setTitle("Feelings", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc func handleObservationButton() {
        let vc = ObservationsViewController()
        guard let navigationController else { fatalError("Could not unwrap navigationController") }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var observationsButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.setTitle("Observations", for: .normal)
        button.addTarget(
            self,
            action: #selector(handleObservationButton),
            for: .touchUpInside
        )
        return button
    }()

    lazy var bottomButtonsStackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [
            feelingsButton, observationsButton,
        ])
        stackView.spacing = 15
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var allButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .systemGray
        button.layer.cornerRadius = 10
        button.setTitle("All", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var buttons: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [
            topButtonsStackView,
            bottomButtonsStackView,
            allButton,
        ])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var priorityLabel: UILabel = {
        var label = UILabel()
        label.text = "High Priority"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var addInsightButton: UIButton = {
        var button = UIButton()
        button.setTitle("Add Insight", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

}

extension HomeScreenView: ViewCodeProtocol {
    func addSubviews() {
        [
            buttons,
            priorityLabel,
            addInsightButton,

        ].forEach({ addSubview($0) })
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            buttons.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            buttons.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            buttons.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),

            priorityLabel.topAnchor.constraint(
                equalTo: buttons.bottomAnchor,
                constant: 16
            ),
            priorityLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            priorityLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),

            addInsightButton.heightAnchor.constraint(equalToConstant: 50),
            addInsightButton.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -57
            ),
            addInsightButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            addInsightButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
        ])
    }

}
