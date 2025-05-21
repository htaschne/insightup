//
//  InsightDetailViewController.swift
//  insightup
//
//  Created by Eduardo Garcia Fensterseifer on 21/05/25.
//

import UIKit

class InsightDetailViewController: UIViewController {
    // MARK: - Properties
    private var insight: Insight
    private var selectedImages: [UIImage] = []
    private var selectedAudios: [URL] = []

    // MARK: - UI Components
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    private lazy var contentStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var propertiesSelector: PropertiesSelector = {
        let selector = PropertiesSelector()
        selector.translatesAutoresizingMaskIntoConstraints = false
        selector.layer.cornerRadius = 16
        selector.clipsToBounds = true
        selector.delegate = self
        return selector
    }()

    private lazy var bottomButtonContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private lazy var analyseButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Analyse with AI"
        config.image = UIImage(systemName: "cpu.fill")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .medium

        let button = UIButton(type: .system)
        button.configuration = config
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(analyseTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    init(insight: Insight) {
        self.insight = insight
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        title = "Insight"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))

        setup()
        configureContent()
    }
}

// MARK: - ViewCodeProtocol
extension InsightDetailViewController: ViewCodeProtocol {
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        view.addSubview(bottomButtonContainer)
        bottomButtonContainer.addSubview(analyseButton)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentStack inside ScrollView
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),

            // Bottom Container
            bottomButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomButtonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomButtonContainer.heightAnchor.constraint(equalToConstant: 80),

            // Analyse Button
            analyseButton.leadingAnchor.constraint(equalTo: bottomButtonContainer.leadingAnchor, constant: 16),
            analyseButton.trailingAnchor.constraint(equalTo: bottomButtonContainer.trailingAnchor, constant: -16),
            analyseButton.bottomAnchor.constraint(equalTo: bottomButtonContainer.bottomAnchor, constant: -16),
            analyseButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

// MARK: - Content Configuration
extension InsightDetailViewController {
    private func configureContent() {
        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // Insight Card
        let card = InsightCardView(insight: insight, dateString: "Added on 19/05/2025")
        card.backgroundColor = .backgroundsTertiary
        contentStack.addArrangedSubview(card)

        // Properties Selector
        let filterItems = makeFilterItems()
        propertiesSelector.configure(with: filterItems)
        contentStack.addArrangedSubview(propertiesSelector)
        propertiesSelector.heightAnchor.constraint(equalToConstant: 207).isActive = true

        // Media Sections
        contentStack.addArrangedSubview(makeMediaSection(title: "Images", items: selectedImages.map { .image($0) }, addAction: #selector(addImageTapped), removeAction: #selector(removeImageTapped(_:))))
        contentStack.addArrangedSubview(makeMediaSection(title: "Audios", items: selectedAudios.map { .audio($0) }, addAction: #selector(addAudioTapped), removeAction: #selector(removeAudioTapped(_:))))
    }

    private func makeFilterItems() -> [PropertyItem] {
        let p = insight.priority.rawValue
        let a = insight.audience.rawValue
        let e = insight.executionEffort.rawValue
        let b = insight.bugdet.rawValue

        return [
            PropertyItem(title: "Priority", iconName: "exclamationmark.triangle.fill", options: [p] + Category.allCases.map { $0.rawValue }.filter { $0 != p }),
            PropertyItem(title: "Audience", iconName: "megaphone.fill", options: [a] + TargetAudience.allCases.map { $0.rawValue }.filter { $0 != a }),
            PropertyItem(title: "Execution Effort", iconName: "person.line.dotted.person.fill", options: [e] + Effort.allCases.map { $0.rawValue }.filter { $0 != e }),
            PropertyItem(title: "Budget", iconName: "dollarsign.gauge.chart.leftthird.topthird.rightthird", options: [b] + Budget.allCases.map { $0.rawValue }.filter { $0 != b })
        ]
    }

    private func makeMediaSection(title: String, items: [MediaItem], addAction: Selector, removeAction: Selector) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 16
        container.backgroundColor = .backgroundsTertiary

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])

        // Header
        let header = UIStackView()
        header.axis = .horizontal
        header.alignment = .center
        header.spacing = 8
        header.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(header)

        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 17, weight: .regular)
        header.addArrangedSubview(label)

        let addBtn = UIButton(type: .system)
        addBtn.setTitle("Add", for: .normal)
        addBtn.addTarget(self, action: addAction, for: .touchUpInside)
        header.addArrangedSubview(addBtn)

        header.addArrangedSubview(UIView()) // spacer

        // Items
        for (idx, item) in items.enumerated() {
            let row = UIStackView()
            row.axis = .horizontal
            row.spacing = 12
            row.alignment = .center
            row.translatesAutoresizingMaskIntoConstraints = false

            let remove = UIButton(type: .system)
            remove.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
            remove.tintColor = .systemRed
            remove.tag = idx
            remove.addTarget(self, action: removeAction, for: .touchUpInside)
            row.addArrangedSubview(remove)

            switch item {
            case .image(let img):
                let imgView = UIImageView(image: img)
                imgView.contentMode = .scaleAspectFit
                imgView.layer.cornerRadius = 6
                imgView.clipsToBounds = true
                imgView.translatesAutoresizingMaskIntoConstraints = false
                imgView.widthAnchor.constraint(equalToConstant: 32).isActive = true
                imgView.heightAnchor.constraint(equalToConstant: 32).isActive = true
                row.addArrangedSubview(imgView)
            case .audio(let url):
                let icon = UIImageView(image: UIImage(systemName: "waveform"))
                icon.contentMode = .scaleAspectFit
                icon.translatesAutoresizingMaskIntoConstraints = false
                icon.widthAnchor.constraint(equalToConstant: 32).isActive = true
                icon.heightAnchor.constraint(equalToConstant: 32).isActive = true
                row.addArrangedSubview(icon)
            }

            let name = UILabel()
            name.text = (item.fileName)
            name.font = .systemFont(ofSize: 17)
            row.addArrangedSubview(name)
            row.addArrangedSubview(UIView())

            stack.addArrangedSubview(row)
        }

        return container
    }
}

// MARK: - Actions & Delegates
extension InsightDetailViewController {
    @objc private func editTapped() {
//        let modal = ModalAddInsightViewController(insight: insight)
//        modal.modalPresentationStyle = .automatic
//        modal.onDone = { [weak self] updated in
//            self?.insight = updated
//            self?.configureContent()
//        }
//        present(modal, animated: true)
        print("Edit Button Tapped")
    }

    @objc private func analyseTapped() {
//        let aiVC = InsightAIAnalysisViewController(insight: insight)
//        navigationController?.pushViewController(aiVC, animated: true)
        print("Analyse Button Tapped")
    }

    @objc private func addImageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    @objc private func removeImageTapped(_ sender: UIButton) {
        selectedImages.remove(at: sender.tag)
        configureContent()
    }

    @objc private func addAudioTapped() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.audio])
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc private func removeAudioTapped(_ sender: UIButton) {
        selectedAudios.remove(at: sender.tag)
        configureContent()
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension InsightDetailViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        if let img = info[.originalImage] as? UIImage {
            selectedImages.append(img)
            configureContent()
        }
    }
}

// MARK: - UIDocumentPickerDelegate
extension InsightDetailViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let url = urls.first {
            selectedAudios.append(url)
            configureContent()
        }
    }
}

// MARK: - PropertiesSelectorDelegate
extension InsightDetailViewController: PropertiesSelectorDelegate {
    func propertiesSelector(_ selector: PropertiesSelector, didSelectItemAt indexPath: IndexPath) {
        let selectedTitle = selector.tableView.cellForRow(at: indexPath) as? SelectorCell
        if indexPath.row == 0, let newTitle = selectedTitle?.btnCategory.configuration?.title,
           let newPriority = Category(rawValue: newTitle) {
            insight.priority = newPriority
            InsightPersistence.updateInsight(updatedInsight: insight)
            NotificationCenter.default.post(name: .init("InsightsDidChange"), object: nil)
            configureContent()
        }
    }
}

enum MediaItem {
    case image(UIImage)
    case audio(URL)
}

private extension MediaItem {
    var fileName: String {
        switch self {
        case .image:
            return "Image"
        case .audio(let url):
            return url.lastPathComponent
        }
    }
}
