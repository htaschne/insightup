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
    
    @objc func handleIdeasButton() {
        let vc = CategoryViewController(category: .Ideas)
        guard let navigationController else { fatalError("Could not unwrap navigationController") }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var ideasButton: CardCategoryComponent = {
        let card = CardCategoryComponent(category: .Ideas)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleIdeasButton))
        card.addGestureRecognizer(tap)
        return card
    }()
    
    @objc func handleProblemsButton() {
        let vc = CategoryViewController(category: .Problems)
        guard let navigationController else { fatalError("Could not unwrap navigationController") }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var problemsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Problems)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProblemsButton))
        card.addGestureRecognizer(tap)
        return card
    }()
    
    @objc func handleFeelingsButton() {
        let vc = CategoryViewController(category: .Feelings)
        guard let navigationController else { fatalError("Could not unwrap navigationController") }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var feelingsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Feelings)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFeelingsButton))
        card.addGestureRecognizer(tap)
        return card
    }()
    
    @objc func handleObservationButton() {
        let vc = CategoryViewController(category: .Observations)
        guard let navigationController else { fatalError("Could not unwrap navigationController") }
        navigationController.pushViewController(vc, animated: true)
    }
    
    lazy var observationsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Observations)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleObservationButton))
        card.translatesAutoresizingMaskIntoConstraints = false
        card.addGestureRecognizer(tap)
        return card
    }()

    @objc func handleAllButton() {
        let vc = CategoryViewController(category: .Observations)
        guard let navigationController else { fatalError("Could not unwrap navigationController") }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var allButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .All)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleAllButton))
        card.addGestureRecognizer(tap)
        return card
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

    lazy var testChatGPTButton: UIButton = {
        var button = UIButton()
        button.setTitle("Test ChatGPT", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTestChatGPT), for: .touchUpInside)
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

    @objc private func handleTestChatGPT() {
        let prompt = "Você é um especialista em negócios. Me dê uma dica de business."
        let chatGPTService = ChatGPTService() // A API Key será lida de APIKeys.swift
        testChatGPTButton.isEnabled = false
        testChatGPTButton.setTitle("Carregando...", for: .normal)
        Task {
            do {
                let response = try await chatGPTService.generateResponse(prompt: prompt)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.testChatGPTButton.isEnabled = true
                    self.testChatGPTButton.setTitle("Test ChatGPT", for: .normal)
                    let alert = UIAlertController(
                        title: "Resposta do ChatGPT",
                        message: response,
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.window?.rootViewController?.present(alert, animated: true)
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.testChatGPTButton.isEnabled = true
                    self.testChatGPTButton.setTitle("Test ChatGPT", for: .normal)
                    let alert = UIAlertController(
                        title: "Erro",
                        message: "\(error)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.window?.rootViewController?.present(alert, animated: true)
                }
            }
        }
    }

}

extension HomeScreenView: ViewCodeProtocol {
    func addSubviews() {
        [
            buttons,
            priorityLabel,
            addInsightButton,
            testChatGPTButton
        ].forEach({ addSubview($0) })
    }

    func addConstraints() {
        ideasButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        problemsButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        feelingsButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        observationsButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        allButton.heightAnchor.constraint(equalToConstant: 100).isActive = true

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

            testChatGPTButton.heightAnchor.constraint(equalToConstant: 50),
            testChatGPTButton.bottomAnchor.constraint(
                equalTo: addInsightButton.topAnchor,
                constant: -16
            ),
            testChatGPTButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            testChatGPTButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
        ])
    }

}
