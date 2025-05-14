import UIKit

class SelectorCell: UITableViewCell {
    static let reuseIdentifier = "SelectorCell"

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .label // ou outra cor que desejar
        return imageView
    }()

    private let lblCategory: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProRounded-Regular", size: 16)
        return label
    }()

    private lazy var btnCategory: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        var configuration = UIButton.Configuration.plain()
        configuration.title = "None"
        configuration.indicator = .popup
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8

        button.configuration = configuration
        button.showsMenuAsPrimaryAction = true

        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(lblCategory)
        contentView.addSubview(btnCategory)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            lblCategory.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            lblCategory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            btnCategory.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            btnCategory.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            lblCategory.trailingAnchor.constraint(lessThanOrEqualTo: btnCategory.leadingAnchor, constant: -8)
        ])
    }

    func configure(title: String, iconName: String, options: [String]) {
        lblCategory.text = title
        iconImageView.image = UIImage(systemName: iconName)

        let menuItems = options.map { option in
            UIAction(title: option) { [weak self] _ in
                var config = self?.btnCategory.configuration
                config?.title = option
                self?.btnCategory.configuration = config
            }
        }

        btnCategory.menu = UIMenu(title: "", options: [.singleSelection], children: menuItems)
    }
}
