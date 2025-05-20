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
        let modalVC = ModalAddInsightViewController(insight: insight)
        modalVC.modalPresentationStyle = .automatic
        modalVC.onDone = { [weak self] updatedInsight in
            guard let self = self else { return }
            self.insight = updatedInsight
            self.setupContent()
        }
        present(modalVC, animated: true)
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
        card.backgroundColor = .backgroundsTertiary
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

        // Seção de imagens como card
        let imageSection = UIView()
        imageSection.backgroundColor = .backgroundsTertiary
        imageSection.layer.cornerRadius = 16
        imageSection.translatesAutoresizingMaskIntoConstraints = false
        let imageStack = UIStackView()
        imageStack.axis = .vertical
        imageStack.spacing = 0
        imageStack.translatesAutoresizingMaskIntoConstraints = false
        imageSection.addSubview(imageStack)
        NSLayoutConstraint.activate([
            imageStack.topAnchor.constraint(equalTo: imageSection.topAnchor),
            imageStack.leadingAnchor.constraint(equalTo: imageSection.leadingAnchor),
            imageStack.trailingAnchor.constraint(equalTo: imageSection.trailingAnchor),
            imageStack.bottomAnchor.constraint(equalTo: imageSection.bottomAnchor)
        ])
        // Botão Add Image
        let addImageButton = UIButton(type: .system)
        addImageButton.setTitle("Add Image", for: .normal)
        addImageButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        addImageButton.contentHorizontalAlignment = .left
        addImageButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        addImageButton.setTitleColor(.systemBlue, for: .normal)
        addImageButton.backgroundColor = .clear
        addImageButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        addImageButton.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        imageStack.addArrangedSubview(addImageButton)
        // Imagens adicionadas
        for (idx, img) in selectedImages.enumerated() {
            let imgRow = UIStackView()
            imgRow.axis = .horizontal
            imgRow.spacing = 12
            imgRow.alignment = .center
            imgRow.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            imgRow.isLayoutMarginsRelativeArrangement = true
            let removeButton = UIButton(type: .system)
            removeButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
            removeButton.tintColor = .systemRed
            removeButton.tag = idx
            removeButton.addTarget(self, action: #selector(removeImageTapped(_:)), for: .touchUpInside)
            imgRow.addArrangedSubview(removeButton)
            let imgView = UIImageView(image: img)
            imgView.contentMode = .scaleAspectFit
            imgView.layer.cornerRadius = 6
            imgView.clipsToBounds = true
            imgView.widthAnchor.constraint(equalToConstant: 32).isActive = true
            imgView.heightAnchor.constraint(equalToConstant: 32).isActive = true
            imgRow.addArrangedSubview(imgView)
            let label = UILabel()
            label.text = "Image"
            label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            imgRow.addArrangedSubview(label)
            imgRow.addArrangedSubview(UIView()) // Spacer
            imgRow.heightAnchor.constraint(equalToConstant: 40).isActive = true
            imageStack.addArrangedSubview(imgRow)
        }
        // Espaço extra no final do card de imagens, apenas se houver imagens
        if !selectedImages.isEmpty {
            let imageBottomSpacer = UIView()
            imageBottomSpacer.heightAnchor.constraint(equalToConstant: 12).isActive = true
            imageStack.addArrangedSubview(imageBottomSpacer)
        }

        // Seção de áudios como card
        let audioSection = UIView()
        audioSection.backgroundColor = .backgroundsTertiary
        audioSection.layer.cornerRadius = 16
        audioSection.translatesAutoresizingMaskIntoConstraints = false
        let audioStack = UIStackView()
        audioStack.axis = .vertical
        audioStack.spacing = 0
        audioStack.translatesAutoresizingMaskIntoConstraints = false
        audioSection.addSubview(audioStack)
        NSLayoutConstraint.activate([
            audioStack.topAnchor.constraint(equalTo: audioSection.topAnchor),
            audioStack.leadingAnchor.constraint(equalTo: audioSection.leadingAnchor),
            audioStack.trailingAnchor.constraint(equalTo: audioSection.trailingAnchor),
            audioStack.bottomAnchor.constraint(equalTo: audioSection.bottomAnchor)
        ])
        // Botão Add Audio
        let addAudioButton = UIButton(type: .system)
        addAudioButton.setTitle("Add Audio", for: .normal)
        addAudioButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        addAudioButton.contentHorizontalAlignment = .left
        addAudioButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        addAudioButton.setTitleColor(.systemBlue, for: .normal)
        addAudioButton.backgroundColor = .clear
        addAudioButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        addAudioButton.addTarget(self, action: #selector(addAudioTapped), for: .touchUpInside)
        audioStack.addArrangedSubview(addAudioButton)
        // Áudios adicionados
        for (idx, url) in selectedAudios.enumerated() {
            let audioRow = UIStackView()
            audioRow.axis = .horizontal
            audioRow.spacing = 12
            audioRow.alignment = .center
            audioRow.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            audioRow.isLayoutMarginsRelativeArrangement = true
            let removeButton = UIButton(type: .system)
            removeButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
            removeButton.tintColor = .systemRed
            removeButton.tag = idx
            removeButton.addTarget(self, action: #selector(removeAudioTapped(_:)), for: .touchUpInside)
            audioRow.addArrangedSubview(removeButton)
            let icon = UIImageView(image: UIImage(systemName: "waveform"))
            icon.tintColor = .label
            icon.contentMode = .scaleAspectFit
            icon.translatesAutoresizingMaskIntoConstraints = false
            icon.widthAnchor.constraint(equalToConstant: 32).isActive = true
            icon.heightAnchor.constraint(equalToConstant: 32).isActive = true
            audioRow.addArrangedSubview(icon)
            let label = UILabel()
            label.text = url.lastPathComponent
            label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            audioRow.addArrangedSubview(label)
            audioRow.addArrangedSubview(UIView()) // Spacer
            audioRow.heightAnchor.constraint(equalToConstant: 40).isActive = true
            audioStack.addArrangedSubview(audioRow)
        }
        // Espaço extra no final do card de áudios, apenas se houver áudios
        if !selectedAudios.isEmpty {
            let audioBottomSpacer = UIView()
            audioBottomSpacer.heightAnchor.constraint(equalToConstant: 12).isActive = true
            audioStack.addArrangedSubview(audioBottomSpacer)
        }

        contentStack.addArrangedSubview(imageSection)
        imageSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
        contentStack.addArrangedSubview(audioSection)
        audioSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 48).isActive = true
    }

    // MARK: PropertiesSelectorDelegate
    func propertiesSelector(_ selector: PropertiesSelector, didSelectItemAt indexPath: IndexPath) {
        // Priority é o primeiro filtro
        if indexPath.row == 0 {
            let selected = selector.tableView.cellForRow(at: indexPath) as? SelectorCell
            let newPriority = selected?.btnCategory.configuration?.title ?? "Low"
            if let newCategory = Category(rawValue: newPriority) {
                insight.priority = newCategory
                // Salvar alteração na persistência
                InsightPersistence.updateInsight(updatedInsight: insight)
                // Notificar Home para atualizar os cards
                NotificationCenter.default.post(name: NSNotification.Name("InsightsDidChange"), object: nil)
                // Atualizar UI
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
        container.backgroundColor = .backgroundsTertiary
        container.layer.cornerRadius = 16
        container.translatesAutoresizingMaskIntoConstraints = false

        // Stack para título e botão
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 8
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(headerStack)
        
        // Título
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .systemBlue
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.textAlignment = .left
        headerStack.addArrangedSubview(titleLabel)
        headerStack.setCustomSpacing(0, after: titleLabel)
        
        // Botão de adicionar
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add", for: .normal)
        addButton.tintColor = .systemBlue
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        addButton.addTarget(self, action: addSelector, for: .touchUpInside)
        headerStack.addArrangedSubview(addButton)
        
        // Spacer para empurrar o botão para a direita
        let spacer = UIView()
        headerStack.addArrangedSubview(spacer)
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            headerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Stack para arquivos
        var lastView: UIView = headerStack
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
        let aiVC = InsightAIAnalysisViewController(insight: insight)
        navigationController?.pushViewController(aiVC, animated: true)
    }
} 
