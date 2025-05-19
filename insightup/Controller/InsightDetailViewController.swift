import UIKit

class InsightDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, PropertiesSelectorDelegate {
    var insight: Insight

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private var propertiesSelector: PropertiesSelector!
    private let analyseButton = UIButton(type: .system)

    // Arrays para imagens e áudios
    private var selectedImages: [UIImage] = []
    private var selectedAudios: [URL] = []

    private let bottomButtonContainer = UIView()

    init(insight: Insight) {
        self.insight = insight
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        title = "Insight"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))

        setupScrollView()
        setupContent()
        setupBottomButton()
    }

    @objc private func editTapped() {
        print("Edit button tapped")
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
    }

    private func setupBottomButton() {
        bottomButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        bottomButtonContainer.backgroundColor = .clear
        view.addSubview(bottomButtonContainer)
        NSLayoutConstraint.activate([
            bottomButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButtonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomButtonContainer.heightAnchor.constraint(equalToConstant: 80)
        ])
        var config = UIButton.Configuration.filled()
        config.title = "Analyse with AI"
        config.image = UIImage(systemName: "cpu.fill")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        analyseButton.configuration = config
        analyseButton.translatesAutoresizingMaskIntoConstraints = false
        analyseButton.addTarget(self, action: #selector(analyseTapped), for: .touchUpInside)
        bottomButtonContainer.addSubview(analyseButton)
        NSLayoutConstraint.activate([
            analyseButton.leadingAnchor.constraint(equalTo: bottomButtonContainer.leadingAnchor, constant: 16),
            analyseButton.trailingAnchor.constraint(equalTo: bottomButtonContainer.trailingAnchor, constant: -16),
            analyseButton.bottomAnchor.constraint(equalTo: bottomButtonContainer.bottomAnchor, constant: -16),
            analyseButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupContent() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // Card do insight
        let card = InsightCardView(
            insight: insight,
            dateString: "Added on 19/05/2025"
        )
        contentStack.addArrangedSubview(card)

        // PropertiesSelector (filtros)
        let priorityOptions = ["Low", "Medium", "High"]
        let audienceOptions = ["B2B", "B2C", "B2B2C", "B2E", "B2G", "C2C", "D2C"]
        let effortOptions = ["Solo", "With 1 other", "2-4 team", "Cross-team +4", "External Help"]
        let budgetOptions = ["< R$100", "R$100-500", "R$500-1000", "R$2k +"]

        let priority = insight.priority.rawValue
        let audience = insight.audience.rawValue
        let effort = insight.executionEffort.rawValue
        let budget = insight.budget.rawValue

        let filterItems = [
            PropertyItem(title: "Priority", iconName: "exclamationmark.triangle.fill", options: [priority] + priorityOptions.filter { $0 != priority }),
            PropertyItem(title: "Audience", iconName: "megaphone.fill", options: [audience] + audienceOptions.filter { $0 != audience }),
            PropertyItem(title: "Execution Effort", iconName: "person.line.dotted.person.fill", options: [effort] + effortOptions.filter { $0 != effort }),
            PropertyItem(title: "Budget", iconName: "dollarsign.gauge.chart.leftthird.topthird.rightthird", options: [budget] + budgetOptions.filter { $0 != budget })
        ]
        propertiesSelector = PropertiesSelector()
        propertiesSelector.configure(with: filterItems)
        propertiesSelector.translatesAutoresizingMaskIntoConstraints = false
        propertiesSelector.layer.cornerRadius = 16
        propertiesSelector.clipsToBounds = true
        propertiesSelector.delegate = self
        contentStack.addArrangedSubview(propertiesSelector)
        propertiesSelector.heightAnchor.constraint(equalToConstant: 207).isActive = true

        // Seção de imagens
        let imageSection = mediaSection(title: "Add Image", items: selectedImages.map { .image($0) }, addSelector: #selector(addImageTapped), removeSelector: #selector(removeImageTapped(_:)))
        contentStack.addArrangedSubview(imageSection)
        imageSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true

        // Seção de áudios
        let audioSection = mediaSection(title: "Add Audio", items: selectedAudios.map { .audio($0) }, addSelector: #selector(addAudioTapped), removeSelector: #selector(removeAudioTapped(_:)))
        contentStack.addArrangedSubview(audioSection)
        audioSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true

        // Espaçador antes do botão fixo
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .vertical)
        contentStack.addArrangedSubview(spacerView)
    }

    // MARK: PropertiesSelectorDelegate
    func propertiesSelector(_ selector: PropertiesSelector, didSelectItemAt indexPath: IndexPath) {
        // Priority é o primeiro filtro
        if indexPath.row == 0 {
            let selected = selector.tableView.cellForRow(at: indexPath) as? SelectorCell
            let newPriority = selected?.btnCategory.configuration?.title ?? "Low"
            if let newCategory = Category(rawValue: newPriority) {
                insight.priority = newCategory
                setupContent()
            }
        }
    }

    enum MediaItem {
        case image(UIImage)
        case audio(URL)
    }

    private func mediaSection(title: String, items: [MediaItem], addSelector: Selector, removeSelector: Selector) -> UIView {
        let container = UIView()
        container.backgroundColor = UIColor.white
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false

        // Título azul
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .systemBlue
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16)
        ])

        // Botão de adicionar (invisível, cobre a área do título)
        let addButton = UIButton(type: .system)
        addButton.backgroundColor = .clear
        addButton.addTarget(self, action: addSelector, for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: container.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Adjust colors for dark mode
        container.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.black
            default:
                return UIColor.white
            }
        }
        titleLabel.textColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor.systemBlue
            default:
                return UIColor.systemBlue
            }
        }

        // Stack para arquivos
        var lastView: UIView = titleLabel
        for (idx, item) in items.enumerated() {
            let fileStack = UIStackView()
            fileStack.axis = .horizontal
            fileStack.spacing = 12
            fileStack.alignment = .center
            fileStack.translatesAutoresizingMaskIntoConstraints = false
            // Botão remover
            let removeButton = UIButton(type: .system)
            removeButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
            removeButton.tintColor = .systemRed
            removeButton.tag = idx
            removeButton.addTarget(self, action: removeSelector, for: .touchUpInside)
            fileStack.addArrangedSubview(removeButton)
            // Preview
            switch item {
            case .image(let img):
                let imgView = UIImageView(image: img)
                imgView.contentMode = .scaleAspectFit
                imgView.layer.cornerRadius = 6
                imgView.clipsToBounds = true
                imgView.translatesAutoresizingMaskIntoConstraints = false
                imgView.widthAnchor.constraint(equalToConstant: 32).isActive = true
                imgView.heightAnchor.constraint(equalToConstant: 32).isActive = true
                fileStack.addArrangedSubview(imgView)
                let label = UILabel()
                label.text = "Image"
                label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
                fileStack.addArrangedSubview(label)
            case .audio(let url):
                let icon = UIImageView(image: UIImage(systemName: "waveform"))
                icon.tintColor = .label
                icon.contentMode = .scaleAspectFit
                icon.translatesAutoresizingMaskIntoConstraints = false
                icon.widthAnchor.constraint(equalToConstant: 32).isActive = true
                icon.heightAnchor.constraint(equalToConstant: 32).isActive = true
                fileStack.addArrangedSubview(icon)
                let label = UILabel()
                label.text = url.lastPathComponent
                label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
                fileStack.addArrangedSubview(label)
            }
            fileStack.addArrangedSubview(UIView()) // Spacer
            container.addSubview(fileStack)
            NSLayoutConstraint.activate([
                fileStack.topAnchor.constraint(equalTo: lastView.bottomAnchor, constant: 8),
                fileStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
                fileStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
                fileStack.heightAnchor.constraint(equalToConstant: 40)
            ])
            lastView = fileStack
        }
        // Ajusta altura mínima
        lastView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8).isActive = true
        return container
    }

    @objc private func addImageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    @objc private func addAudioTapped() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func removeImageTapped(_ sender: UIButton) {
        let idx = sender.tag
        guard idx < selectedImages.count else { return }
        selectedImages.remove(at: idx)
        setupContent()
    }

    @objc private func removeAudioTapped(_ sender: UIButton) {
        let idx = sender.tag
        guard idx < selectedAudios.count else { return }
        selectedAudios.remove(at: idx)
        setupContent()
    }

    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let img = info[.originalImage] as? UIImage {
            selectedImages.append(img)
            setupContent()
        }
    }

    // MARK: - UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            selectedAudios.append(url)
            setupContent()
        }
    }

    @objc private func analyseTapped() {
        let aiVC = AIAnalyzingViewController()
        aiVC.modalPresentationStyle = .fullScreen
        present(aiVC, animated: true)
    }
} 
