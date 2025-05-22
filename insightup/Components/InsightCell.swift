//
//  InsightCell.swift
//  insightup
//
//  Created by Agatha Schneider on 13/05/25.
//

import UIKit

class InsightCell: UITableViewCell {

    public static let reuseIdentifier = "InsightCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .label
        return label
    }()

    private let priorityIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemRed
        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(priorityIcon)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            priorityIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            priorityIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            priorityIcon.widthAnchor.constraint(equalToConstant: 20),
            priorityIcon.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: priorityIcon.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            dateLabel.widthAnchor.constraint(equalToConstant: 80)
        ])
    }

    func configure(with insight: Insight) {
        titleLabel.text = insight.title
        
        // Configure priority icon
        let priorityImage: String
        switch insight.priority {
        case .High:
            priorityImage = "exclamationmark.triangle.fill"
        case .Medium:
            priorityImage = "exclamationmark.circle.fill"
        case .Low:
            priorityImage = "exclamationmark.circle"
        case .None:
            priorityImage = "circle"
        }
        priorityIcon.image = UIImage(systemName: priorityImage)
        
        // Configure date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        dateLabel.text = formatter.string(from: insight.createdAt)
    }
}
