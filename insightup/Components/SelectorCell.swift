import UIKit

class SelectorCell: UITableViewCell {
    static let reuseIdentifier = "SelectorCell"

    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = UIColor(named: "ColorsBlue")
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    lazy var lblCategory: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFProRounded-Regular", size: 16)
        return label
    }()

    lazy var btnCategory: UIButton = {
        var button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        var configuration = UIButton.Configuration.plain()
        configuration.title = "None"
        configuration.baseForegroundColor = UIColor(named: "LabelsSecondary")
        configuration.indicator = .popup
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8

        button.configuration = configuration
        button.showsMenuAsPrimaryAction = true

        return button
    }()
    
    lazy var iconLabelStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [iconImageView, lblCategory])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()
    
    lazy var spacer: UIView = {
        var spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return spacer
    }()
    
    lazy var stackView: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [iconLabelStack, spacer, btnCategory])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor(named: "BackgroundsTertiary")
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String, iconName: String, options: [String]) {
        lblCategory.text = title
        iconImageView.image = UIImage(
            systemName: iconName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        )

        if options.isEmpty {
            // For media buttons (Add Image, Add Audio)
            btnCategory.isHidden = true
        } else {
            btnCategory.isHidden = false
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
}

extension SelectorCell: ViewCodeProtocol {
    func addSubviews() {
        contentView.addSubview(stackView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
      
            stackView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
            
        ])
    }
}
