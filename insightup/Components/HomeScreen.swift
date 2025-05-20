//
//  HomeScreenView.swift
//  insightup
//
//  Created by Agatha Schneider on 13/05/25.
//

import UIKit

class HomeScreenView: UIView {

    private var topInsights: [Insight] = []

    var navigationController: UINavigationController?

    private func loadTopInsights() {
        let allInsights = InsightPersistence.getAll().insights

        let priorityOrder: [Category] = [.High, .Medium, .Low, .None]
        let sortedInsights = allInsights.sorted {
            guard let firstIndex = priorityOrder.firstIndex(of: $0.priority),
                let secondIndex = priorityOrder.firstIndex(of: $1.priority)
            else {
                return false
            }
            return firstIndex < secondIndex
        }

        topInsights = Array(sortedInsights.prefix(3))
        highPriorityTableView.isHidden = topInsights.isEmpty
        priorityLabel.isHidden = topInsights.isEmpty
        highPriorityTableView.reloadData()
    }

    init(navigationController: UINavigationController) {
        super.init(frame: .zero)
        self.navigationController = navigationController
        setup()
        loadTopInsights()
    }

    @objc func handleIdeasButton() {
        let vc = CategoryViewController(category: .Ideas)
        guard let navigationController else {
            fatalError("Could not unwrap navigationController")
        }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var ideasButton: CardCategoryComponent = {
        let card = CardCategoryComponent(category: .Ideas)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleIdeasButton)
        )
        card.addGestureRecognizer(tap)
        return card
    }()

    @objc func handleProblemsButton() {
        let vc = CategoryViewController(category: .Problems)
        guard let navigationController else {
            fatalError("Could not unwrap navigationController")
        }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var problemsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Problems)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleProblemsButton)
        )
        card.addGestureRecognizer(tap)
        return card
    }()

    @objc func handleFeelingsButton() {
        let vc = CategoryViewController(category: .Feelings)
        guard let navigationController else {
            fatalError("Could not unwrap navigationController")
        }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var feelingsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Feelings)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleFeelingsButton)
        )
        card.addGestureRecognizer(tap)
        return card
    }()

    @objc func handleObservationButton() {
        let vc = CategoryViewController(category: .Observations)
        guard let navigationController else {
            fatalError("Could not unwrap navigationController")
        }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var observationsButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .Observations)
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleObservationButton)
        )
        card.translatesAutoresizingMaskIntoConstraints = false
        card.addGestureRecognizer(tap)
        return card
    }()

    @objc func handleAllButton() {
        let vc = CategoryViewController(category: .All)
        guard let navigationController else {
            fatalError("Could not unwrap navigationController")
        }
        navigationController.pushViewController(vc, animated: true)
    }

    lazy var allButton: CardCategoryComponent = {
        var card = CardCategoryComponent(category: .All)
        card.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleAllButton)
        )
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

    lazy var highPriorityTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 44
        tableView.register(
            HighPriorityInsightCell.self,
            forCellReuseIdentifier: HighPriorityInsightCell.reuseIdentifier
        )
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    @objc func handleAddInsight() {
        let vc = ModalAddInsightViewController()
        vc.modalPresentationStyle = .pageSheet
        navigationController?.present(vc, animated: true)
    }

    lazy var addInsightButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Add Insight"
        config.image = UIImage(systemName: "plus")
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.contentInsets = .init(
            top: 14,
            leading: 16,
            bottom: 14,
            trailing: 16
        )
        config.baseBackgroundColor = .colorsBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .medium

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = config
        button.layer.cornerRadius = 8
        button.addTarget(
            self,
            action: #selector(handleAddInsight),
            for: .touchUpInside
        )

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

    lazy var responseTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 14)
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 8
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        loadTopInsights()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        loadTopInsights()
    }

    @objc private func handleTestChatGPT() {
        let prompt = """
{
  "title": "Lançamento de Webinar Educativo",
  "description": "Organizar um webinar de 60 minutos sobre automações de IA para pequenos empreendedores, com demonstrações práticas e Q&A ao vivo.",
  "category": "Ideas",
  "priority": "High",
  "audience": "B2B2C",
  "budget": "R$500-1000"
}
"""
        let instructions = """
Você é um especialista em negócios e empreendedorismo, com ampla experiência em análise de ideias, problemas, sentimentos e observações de mercado.  
Quando receber um JSON contendo os campos:
  • title (string)  
  • description (string)  
  • category (string opcional: Ideas | Problems | Feelings | Observations | None)  
  • priority (string opcional: Low | Medium | High)  
  • audience (string opcional: B2B | B2C | B2B2C | B2E | B2G | C2C | D2C)  
  • budget (string opcional: < R$100 | R$100-500 | R$500-1000 | R$2k +)  

Faça uma análise completa e responda **exclusivamente** com um JSON contendo estes campos:

  1. title (mesmo valor do input)  
  2. feasibility (string, ex.: 79% - High Potential)  
  3. estimated_time (string, ex.: 2 – 3 months)  
  4. estimated_cost (string, ex.: R$1.000 – R$3.000)  
  5. target_audience (string, ex.: B2C – Doctors)  
  6. key_recommendations (array de strings, bullet points)  
  7. strengths (array de strings)  
  8. weaknesses (array de strings)  
  9. contextual_analysis (string, texto corrido)  
  10. suggested_next_steps (array de strings)  

**Regras adicionais**:
- Se algum campo opcional do input estiver ausente ou vazio, o output continuará válido; use valor `None` ou liste arrays vazias conforme fizer sentido.  
- Todos os percentuais e estimativas devem ser fundamentados no conteúdo do input, com justificativas implícitas.  
- Estruture bullets como elementos de arrays JSON, não use caracteres extras (–, •, etc.).  
- Não inclua nenhum texto fora do JSON de resposta.
"""
        let chatGPTService = ChatGPTService()
        testChatGPTButton.isEnabled = false
        testChatGPTButton.setTitle("Carregando...", for: .normal)
        responseTextView.text = "Aguardando resposta..."
        
        Task {
            do {
                let response = try await chatGPTService.generateResponse(prompt: prompt, instructions: instructions)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.testChatGPTButton.isEnabled = true
                    self.testChatGPTButton.setTitle("Test ChatGPT", for: .normal)
                    self.responseTextView.text = response
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.testChatGPTButton.isEnabled = true
                    self.testChatGPTButton.setTitle("Test ChatGPT", for: .normal)
                    self.responseTextView.text = "Erro: \(error)"
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
            highPriorityTableView,
            addInsightButton,
            testChatGPTButton,
            responseTextView
        ].forEach({ addSubview($0) })
    }

    func addConstraints() {
        ideasButton.heightAnchor.constraint(equalToConstant: 81).isActive = true
        problemsButton.heightAnchor.constraint(equalToConstant: 81).isActive =
            true
        feelingsButton.heightAnchor.constraint(equalToConstant: 81).isActive =
            true
        observationsButton.heightAnchor.constraint(equalToConstant: 81)
            .isActive = true
        allButton.heightAnchor.constraint(equalToConstant: 81).isActive = true

        NSLayoutConstraint.activate([
            buttons.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            buttons.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            buttons.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

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
            highPriorityTableView.topAnchor.constraint(
                equalTo: priorityLabel.bottomAnchor,
                constant: 8
            ),
            highPriorityTableView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            highPriorityTableView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            highPriorityTableView.heightAnchor.constraint(
                equalToConstant: (44 * 3 - 1)
            ),

            responseTextView.topAnchor.constraint(
                equalTo: priorityLabel.bottomAnchor,
                constant: 16
            ),
            responseTextView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            responseTextView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            responseTextView.heightAnchor.constraint(equalToConstant: 200),

            addInsightButton.heightAnchor.constraint(equalToConstant: 50),
            addInsightButton.topAnchor.constraint(
                equalTo: highPriorityTableView.bottomAnchor,
                constant: 16
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

extension HomeScreenView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return topInsights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HighPriorityInsightCell.reuseIdentifier,
                for: indexPath
            ) as? HighPriorityInsightCell
        else {
            return UITableViewCell()
        }
        cell.configure(with: topInsights[indexPath.row])
        return cell
    }
}

extension HomeScreenView: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        print("selected row \(indexPath)")
    }

}
