import UIKit

protocol SelectorCellDelegate: AnyObject {
    func selectorCell(_ cell: SelectorCell, didUpdateSelectedOptions selected: [String])
}

class SelectorCell: UITableViewCell {
    static let reuseIdentifier = "SelectorCell"

    weak var delegate: SelectorCellDelegate?

    private var selectedOptions: Set<String> = [] {
        didSet {
            if let currentItem {
                builMenu(for: currentItem)
            }
        }
    }
    private var allOptions: [String] = []
    private var isMultipleSelection: Bool = false
    private var currentItem: PropertyItem?

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
        configuration.title = "Nenhum"
        configuration.baseForegroundColor = UIColor(named: "LabelsSecondary")
        configuration.indicator = .popup
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 8

        button.configuration = configuration
        button.showsMenuAsPrimaryAction = true
        
        button.titleLabel?.textAlignment = .right

        return button
    }()

    lazy var iconLabelStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconImageView, lblCategory])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 16
        return stackView
    }()

    lazy var spacer: UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return spacer
    }()

    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconLabelStack, spacer, btnCategory])
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

    func configure(with item: PropertyItem, editable: Bool) {
        currentItem = item
        lblCategory.text = item.title
        btnCategory.isUserInteractionEnabled = editable
        iconImageView.image = UIImage(
            systemName: item.iconName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        )

        allOptions = item.options
        selectedOptions = Set(item.selectedOptions)
        isMultipleSelection = item.multipleSelection
        updateButtonTitle()
        builMenu(for: item)
        
    }
    
    func builMenu(for item: PropertyItem) {
        let menuItems = allOptions.map { option in
            UIAction(title: option, state: selectedOptions.contains(option) ? .on : .off) { [weak self] action in
                guard let self = self else { return }

                if self.isMultipleSelection {
                    if self.selectedOptions.contains(option) {
                        self.selectedOptions.remove(option)
                    } else {
                        self.selectedOptions.insert(option)
                    }
                } else {
                    self.selectedOptions = [option]
                }

                self.updateButtonTitle()

                self.delegate?.selectorCell(self, didUpdateSelectedOptions: Array(self.selectedOptions))
            }
        }

        btnCategory.menu = UIMenu(title: "", options: .displayInline, children: menuItems)
    }

    private func updateButtonTitle() {
        var newConfig = btnCategory.configuration ?? UIButton.Configuration.plain()

        if selectedOptions.isEmpty {
            newConfig.title = "None"
        } else if selectedOptions.count == 1 {
            newConfig.title = selectedOptions.first
        } else {
            newConfig.title = "\(selectedOptions.count) Selected"
        }

        btnCategory.configuration = newConfig
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
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
                        
            iconImageView.widthAnchor.constraint(equalToConstant: 35),
            iconImageView.heightAnchor.constraint(equalToConstant: 24)
            
        ])
    }
}
