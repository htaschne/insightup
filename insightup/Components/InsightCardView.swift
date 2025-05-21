//
//  InsightCardView.swift
//  insightup
//
//  Created by Eduardo Garcia Fensterseifer on 21/05/25.
//

import UIKit

class InsightCardView: UIView {

    // MARK: - Constants
    private static let dotSize: CGFloat = 16
    private static let stackSpacing: CGFloat = 8
    private static let mainStackPadding: CGFloat = 12
    private static let priorityTagWidth: CGFloat = 60
    private static let priorityTagHeight: CGFloat = 24

    private let categoryDot = UIView()
    private let categoryLabel = UILabel()
    private let priorityTag = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let topStack = UIStackView()
    private let mainStack = UIStackView()

    init(insight: Insight, dateString: String) {
        super.init(frame: .zero)
        setup(insight: insight, dateString: dateString)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(insight: Insight, dateString: String) {
        // Bolinha da categoria
        categoryDot.translatesAutoresizingMaskIntoConstraints = false
        categoryDot.backgroundColor = insight.category.color
        categoryDot.layer.cornerRadius = Self.dotSize / 2
        categoryDot.widthAnchor.constraint(equalToConstant: Self.dotSize).isActive = true
        categoryDot.heightAnchor.constraint(equalToConstant: Self.dotSize).isActive = true
        categoryDot.isAccessibilityElement = true
        categoryDot.accessibilityLabel = "Category color dot for \(insight.category.rawValue)"
        categoryDot.accessibilityTraits = .staticText

        // Nome da categoria
        categoryLabel.text = insight.category.rawValue
        categoryLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        categoryLabel.adjustsFontForContentSizeCategory = true
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.isAccessibilityElement = true
        categoryLabel.accessibilityLabel = "Category: \(insight.category.rawValue)"
        categoryLabel.accessibilityTraits = .staticText

        // Tag de prioridade
        priorityTag.text = insight.priority.rawValue.capitalized
        priorityTag.font = UIFont.preferredFont(forTextStyle: .caption1)
        priorityTag.adjustsFontForContentSizeCategory = true
        priorityTag.textColor = .white
        priorityTag.backgroundColor = colorForPriority(insight.priority)
        priorityTag.layer.cornerRadius = 8
        priorityTag.clipsToBounds = true
        priorityTag.textAlignment = .center
        priorityTag.translatesAutoresizingMaskIntoConstraints = false
        priorityTag.widthAnchor.constraint(equalToConstant: Self.priorityTagWidth).isActive = true
        priorityTag.heightAnchor.constraint(equalToConstant: Self.priorityTagHeight).isActive = true
        priorityTag.isAccessibilityElement = true
        priorityTag.accessibilityLabel = "Priority: \(insight.priority.rawValue.capitalized)"
        priorityTag.accessibilityTraits = .staticText

        // Título
        titleLabel.text = insight.title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isAccessibilityElement = true
        titleLabel.accessibilityLabel = "Title: \(insight.title)"
        titleLabel.accessibilityTraits = .header

        // Descrição
        descriptionLabel.text = insight.notes
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .body)
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.isAccessibilityElement = true
        descriptionLabel.accessibilityLabel = "Description: \(insight.notes)"
        descriptionLabel.accessibilityTraits = .staticText

        // Data
        dateLabel.text = dateString
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.textColor = .systemGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.isAccessibilityElement = true
        dateLabel.accessibilityLabel = "Added on: \(dateString)"
        dateLabel.accessibilityTraits = .staticText

        // Top stack: bolinha + categoria + prioridade
        topStack.axis = .horizontal
        topStack.spacing = Self.stackSpacing
        topStack.alignment = .center
        topStack.translatesAutoresizingMaskIntoConstraints = false
        topStack.addArrangedSubview(categoryDot)
        topStack.addArrangedSubview(categoryLabel)
        topStack.addArrangedSubview(priorityTag)

        // Main stack
        mainStack.axis = .vertical
        mainStack.spacing = Self.stackSpacing
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.addArrangedSubview(topStack)
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(descriptionLabel)
        mainStack.addArrangedSubview(dateLabel)

        addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: Self.mainStackPadding),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.mainStackPadding),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Self.mainStackPadding),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Self.mainStackPadding)
        ])
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        layer.masksToBounds = true
        isAccessibilityElement = false
    }

    private func colorForPriority(_ priority: Category) -> UIColor {
        switch priority {
        case .High: return .systemRed
        case .Medium: return .systemOrange
        case .Low: return .systemGreen
        default: return .systemGray
        }
    }

}
