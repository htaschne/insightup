import UIKit

class AIAnalyzingViewController: UIViewController {
    private let spinner = UIActivityIndicatorView(style: .large)
    private let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemGroupedBackground
        setupUI()
    }

    private func setupUI() {
        // Título
        navigationItem.title = "IA Analyse"
        // Spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor.systemBlue
        spinner.startAnimating()
        view.addSubview(spinner)
        // Label
        label.text = "AI analyzing..."
        label.textColor = UIColor.systemBlue
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        // Stack centralizado
        let stack = UIStackView(arrangedSubviews: [spinner, label])
        stack.axis = .vertical
        stack.spacing = 24
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
} 