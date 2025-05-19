//
//  OnboardingContentViewController.swift
//  insightup
//
//  Created by Enzo Tonatto on 15/05/25.
//

import UIKit

class OnboardingContentViewController: UIViewController {
    // MARK: Subviews
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .labelsSecondary
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.tintColor = .white
        button.backgroundColor = .colorsBlue
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        return button
    }()
    
    private lazy var optionsTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.backgroundView = nil
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "OptionCell")
        return tableView
    }()
    
    private let optionsStack: UIStackView = {
      let stack = UIStackView()
      stack.axis = .vertical
      stack.spacing = 16
      stack.translatesAutoresizingMaskIntoConstraints = false
      return stack
    }()
    
    private let skipButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Skip", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        btn.backgroundColor = .systemGray4
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let infoImageView: UIImageView = {
      let iv = UIImageView()
      iv.contentMode = .scaleAspectFit
      iv.translatesAutoresizingMaskIntoConstraints = false
      return iv
    }()

    // MARK: Data for singleChoice
    
    private var singleTitles: [String] = []
    private var singleSubtitles: [String] = []
    private var selectedIndex: Int?
    private var singleOnSelect: ((Int) -> Void)?
    
    // MARK: Data for multichoice

    private var multiOnSelect: (([Int]) -> Void)?
    
    // MARK: Data
    let page : OnboardingPage
    var buttonAction: (() -> Void)?
    var preselected: [Int] = []

    // MARK: Init
    init(page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        view.backgroundColor = .backgroundsGroupedPrimary
        apply(page: page)
        configureOptions(for: page.type)
        
        preselected.forEach { idx in
          if let btn = view.viewWithTag(idx) as? UIButton {
            btn.isSelected = true
            updateButtonStyle(btn)
          }
        }

        
        preselected.forEach { selectOption(at: $0) }

        optionsTable.rowHeight = 60
        optionsTable.estimatedRowHeight = 60
    }
    
    private func selectOption(at index: Int) {
        if let btn = optionsStack.arrangedSubviews[index] as? UIButton {
            if !btn.isSelected {
                btn.sendActions(for: .touchUpInside)
            }
        }
    }
    
    private func configureOptions(for type: OnboardingPageType) {
      optionsTable.isHidden = true
      optionsStack.isHidden = true
      infoImageView.isHidden = true
        
      optionsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
      selectedIndex = nil
        
      switch type {
      case .info:
          infoImageView.isHidden = false
          skipButton.isHidden = true
          if let name = page.imageName {
              infoImageView.image = UIImage(named: name)
          }

      case .singleChoice(let options, let onSelect):
        self.singleTitles     = options.map { $0.title }
        self.singleSubtitles  = options.map { $0.subtitle }
        self.singleOnSelect   = onSelect
        self.selectedIndex    = nil

        optionsTable.isHidden = false
        optionsTable.reloadData()

      case .multiChoice(let options, let onSelect):
          optionsStack.isHidden = false
          optionsTable.isHidden = true
          multiOnSelect = onSelect

          let columns = options.count > 6 ? 2 : 1
          let rowCount = Int(ceil(Double(options.count) / Double(columns)))

          for row in 0..<rowCount {
              let rowStack = UIStackView()
              rowStack.axis = .horizontal
              rowStack.distribution = .fillEqually
              rowStack.spacing = 12

              for col in 0..<columns {
                  let idx = row * columns + col
                  guard idx < options.count else { break }
                  let btn = makeOptionButton(text: options[idx], tag: idx, single: false)
                  rowStack.addArrangedSubview(btn)
              }

              optionsStack.addArrangedSubview(rowStack)
          }

      }
    }
    
    private func makeOptionButton(text: String, tag: Int, single: Bool) -> UIButton {
      let b = UIButton(type: .system)
      b.setTitle(text, for: .normal)
      b.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
      
      b.contentHorizontalAlignment = .center
      b.heightAnchor.constraint(equalToConstant: 42).isActive = true
      
      b.backgroundColor = .white
      b.setTitleColor(.label, for: .normal)
      b.layer.cornerRadius = 10
      b.layer.borderWidth = 1
      b.layer.borderColor = UIColor.graysGray5.cgColor
      
      b.tag = tag
      b.addTarget(self, action: #selector(handleOptionTap(_:)), for: .touchUpInside)
      return b
    }

    private func updateButtonStyle(_ button: UIButton) {
        if button.isSelected {
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.layer.borderColor = UIColor.clear.cgColor
        } else {
            button.backgroundColor = .white
            button.setTitleColor(.label, for: .normal)
            button.layer.borderColor = UIColor.systemGray4.cgColor
        }
    }

    @objc private func handleOptionTap(_ sender: UIButton) {
        switch page.type {
        case .singleChoice(_, let onSelect):
            optionsStack.arrangedSubviews
                .compactMap { $0 as? UIStackView }
                .flatMap { $0.arrangedSubviews }
                .compactMap { $0 as? UIButton }
                .forEach {
                    $0.isSelected = false
                    updateButtonStyle($0)
                }
            sender.isSelected = true
            updateButtonStyle(sender)
            onSelect(sender.tag)

        case .multiChoice(_, let onSelect):
            sender.isSelected.toggle()
            updateButtonStyle(sender)

            let selected = optionsStack.arrangedSubviews
                .compactMap { $0 as? UIStackView }
                .flatMap { $0.arrangedSubviews }
                .compactMap { $0 as? UIButton }
                .filter { $0.isSelected }
                .map { $0.tag }
            onSelect(selected)

        default:
            break
        }
    }
    
    private func apply(page: OnboardingPage) {
        titleLabel.text = page.title
        descriptionLabel.text = page.description
        if let actionTitle = page.buttonTitle {
            actionButton.setTitle(actionTitle, for: .normal)
        } else {
            actionButton.isHidden = true
        }
    }
    
    @objc private func handleActionButton() {
        buttonAction?()
    }
    
    @objc private func handleSkipButton() {
        buttonAction?()
    }

}

extension OnboardingContentViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
    return singleTitles.count
  }

    func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
        let cell = tv.dequeueReusableCell(withIdentifier: "OptionCell", for: ip)
        
        var config = UIListContentConfiguration.subtitleCell()
        
        config.text = singleTitles[ip.row]
        config.textProperties.font = .systemFont(ofSize: 17, weight: .regular)
        config.textProperties.numberOfLines = 0
        
        config.secondaryText = singleSubtitles[ip.row]
        config.secondaryTextProperties.font = .systemFont(ofSize: 15, weight: .regular)
        config.secondaryTextProperties.color = .labelsSecondary
        
        let symbol = (ip.row == selectedIndex)
        ? "checkmark.circle.fill"
          : "circle"
        config.image = UIImage(systemName: symbol)
        config.imageProperties.tintColor = .colorsBlue
        config.imageToTextPadding = 12
        
        cell.contentConfiguration = config
        cell.accessoryType = .none
        
        return cell
    }


  func tableView(_ tv: UITableView, didSelectRowAt ip: IndexPath) {
    selectedIndex = ip.row
    tv.reloadData()
    singleOnSelect?(ip.row)
  }
}

extension OnboardingContentViewController: ViewCodeProtocol {
    func addSubviews() {
        [titleLabel,
         descriptionLabel,
         infoImageView,
         actionButton,
         optionsTable,
         optionsStack,
         skipButton
        ].forEach {
            subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(subview)
        }
        
        actionButton.addTarget(self, action: #selector(handleActionButton),for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(handleSkipButton), for: .touchUpInside)
    }

    
    func addConstraints() {
        NSLayoutConstraint.activate([
                    titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
                    titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
                    titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

                    descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                    descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
                    descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
                    
                    infoImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 64),
                    infoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

                    actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -116),
                    actionButton.heightAnchor.constraint(equalToConstant: 50),
                    actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    
                    skipButton.leadingAnchor.constraint(equalTo: actionButton.leadingAnchor),
                    skipButton.trailingAnchor.constraint(equalTo: actionButton.trailingAnchor),
                    skipButton.heightAnchor.constraint(equalTo: actionButton.heightAnchor),
                    skipButton.topAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: 16),
                    
                    optionsTable.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
                    optionsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                    optionsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                    optionsTable.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -50),

                    
                    optionsStack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 64),
                    optionsStack.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor),
                    optionsStack.trailingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor),
                    optionsStack.topAnchor.constraint(lessThanOrEqualTo: actionButton.topAnchor, constant: -24)


                ])
    }
    
    
}
