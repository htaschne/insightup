//
//  CardCategoryComponent.swift
//  insightup
//
//  Created by Eduardo Garcia Fensterseifer on 13/05/25.
//

import UIKit

class CardCategoryComponent: UIView {

    private let iconBackgroundView = UIView()
    private let icon = UIImageView()
    private let counter = UILabel()
    private let title = UILabel()
    private let iconCounterStack = UIStackView()
    private let fullStack = UIStackView()
    private let category: InsightCategory
    
    var counterValue: String? {
        didSet {
            counter.text = counterValue
        }
    }

    init(category: InsightCategory) {
        self.category = category
        super.init(frame: .zero)
        setupViews()
        configure(with: category)
        setup()
        updateCounter()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        // Icon background circle
        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        iconBackgroundView.layer.cornerRadius = 17
        iconBackgroundView.clipsToBounds = true
        iconBackgroundView.widthAnchor.constraint(equalToConstant: 32)
            .isActive = true
        iconBackgroundView.heightAnchor.constraint(equalToConstant: 32)
            .isActive = true

        // Icon
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .white
        icon.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        iconBackgroundView.addSubview(icon)

        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(
                equalTo: iconBackgroundView.centerXAnchor
            ),
            icon.centerYAnchor.constraint(
                equalTo: iconBackgroundView.centerYAnchor
            ),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20),
        ])

        // Counter
        counter.translatesAutoresizingMaskIntoConstraints = false
        counter.font = .systemFont(ofSize: 24, weight: .semibold)
        counter.textColor = .label
        counter.textAlignment = .right
        counter.text = "1"

        // Top stack: icon + counter
        iconCounterStack.axis = .horizontal
        iconCounterStack.spacing = 8
        iconCounterStack.translatesAutoresizingMaskIntoConstraints = false
        iconCounterStack.addArrangedSubview(iconBackgroundView)
        iconCounterStack.addArrangedSubview(counter)

        // Title
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 17, weight: .semibold)
        title.textColor = UIColor(named: "GraysGray") ?? .gray
        title.textAlignment = .left

        // Full stack
        fullStack.axis = .vertical
        fullStack.spacing = 11
        fullStack.translatesAutoresizingMaskIntoConstraints = false
        fullStack.addArrangedSubview(iconCounterStack)
        fullStack.addArrangedSubview(title)

        backgroundColor = UIColor(named: "BackgroundsPrimary") ?? .red
        layer.cornerRadius = 12
    }
    
    func updateCounter() {
        let allInsights = InsightPersistence.getAll().insights
        
        let matchingCount: Int
        if category == .All {
            matchingCount = allInsights.count
        } else {
            matchingCount = allInsights.filter { $0.category == category }.count
        }
        
        self.counterValue = "\(matchingCount)"
    }

    private func configure(with category: InsightCategory) {
        icon.image = UIImage(systemName: category.imageName)
        iconBackgroundView.backgroundColor = category.color
        title.text = category.rawValue
    }
}

extension CardCategoryComponent: ViewCodeProtocol {
    func addSubviews() {
        addSubview(fullStack)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            fullStack.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            fullStack.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -10
            ),
            fullStack.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            fullStack.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
        ])
    }
}
