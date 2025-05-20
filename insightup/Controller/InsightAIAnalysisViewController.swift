import UIKit

class InsightAIAnalysisViewController: UIViewController {
    
    let insight: Insight
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Header
    private let headerStack = UIStackView()
    private let dotView = UIView()
    private let analysisTitleLabel = UILabel()
    private let badgeLabel = UILabel()
    
    // Custom Segmented Control
    private let segmentBackground = UIView()
    private let overviewButton = UIButton(type: .system)
    private let detailsButton = UIButton(type: .system)
    private var isOverviewSelected = true
    
    // Content Views
    private let overviewStack = UIStackView()
    private let detailsStack = UIStackView()
    
    // MARK: - Lifecycle
    init(insight: Insight) {
        self.insight = insight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "IA Analyse"
        setupUI()
        showOverview()
    }
    
    // MARK: - Setup
    private func setupUI() {
        // ScrollView setup
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Header
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 10
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headerStack)
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
        
        dotView.translatesAutoresizingMaskIntoConstraints = false
        dotView.backgroundColor = .systemGreen
        dotView.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            dotView.widthAnchor.constraint(equalToConstant: 20),
            dotView.heightAnchor.constraint(equalToConstant: 20)
        ])
        headerStack.addArrangedSubview(dotView)
        
        analysisTitleLabel.text = "Title Generated"
        analysisTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        analysisTitleLabel.textColor = .label
        analysisTitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        headerStack.addArrangedSubview(analysisTitleLabel)
        
        badgeLabel.text = "Low"
        badgeLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        badgeLabel.textColor = .white
        badgeLabel.backgroundColor = .systemGreen
        badgeLabel.layer.cornerRadius = 14
        badgeLabel.clipsToBounds = true
        badgeLabel.textAlignment = .center
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeLabel.widthAnchor.constraint(equalToConstant: 60),
            badgeLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
        headerStack.addArrangedSubview(badgeLabel)
        
        // Custom Segmented Control
        segmentBackground.translatesAutoresizingMaskIntoConstraints = false
        segmentBackground.backgroundColor = .secondarySystemBackground
        segmentBackground.layer.cornerRadius = 16
        contentView.addSubview(segmentBackground)
        NSLayoutConstraint.activate([
            segmentBackground.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 24),
            segmentBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            segmentBackground.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            segmentBackground.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        overviewButton.setTitle("Overview", for: .normal)
        overviewButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        overviewButton.layer.cornerRadius = 14
        overviewButton.translatesAutoresizingMaskIntoConstraints = false
        overviewButton.addTarget(self, action: #selector(showOverview), for: .touchUpInside)
        segmentBackground.addSubview(overviewButton)
        
        detailsButton.setTitle("Details", for: .normal)
        detailsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        detailsButton.layer.cornerRadius = 14
        detailsButton.translatesAutoresizingMaskIntoConstraints = false
        detailsButton.addTarget(self, action: #selector(showDetails), for: .touchUpInside)
        segmentBackground.addSubview(detailsButton)
        
        NSLayoutConstraint.activate([
            overviewButton.topAnchor.constraint(equalTo: segmentBackground.topAnchor, constant: 4),
            overviewButton.bottomAnchor.constraint(equalTo: segmentBackground.bottomAnchor, constant: -4),
            overviewButton.leadingAnchor.constraint(equalTo: segmentBackground.leadingAnchor, constant: 4),
            overviewButton.widthAnchor.constraint(equalTo: segmentBackground.widthAnchor, multiplier: 0.5, constant: -6),
            
            detailsButton.topAnchor.constraint(equalTo: segmentBackground.topAnchor, constant: 4),
            detailsButton.bottomAnchor.constraint(equalTo: segmentBackground.bottomAnchor, constant: -4),
            detailsButton.trailingAnchor.constraint(equalTo: segmentBackground.trailingAnchor, constant: -4),
            detailsButton.widthAnchor.constraint(equalTo: segmentBackground.widthAnchor, multiplier: 0.5, constant: -6)
        ])
        
        // Overview Stack
        overviewStack.axis = .vertical
        overviewStack.spacing = 18
        overviewStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(overviewStack)
        NSLayoutConstraint.activate([
            overviewStack.topAnchor.constraint(equalTo: segmentBackground.bottomAnchor, constant: 24),
            overviewStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            overviewStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            overviewStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])
        
        // Details Stack
        detailsStack.axis = .vertical
        detailsStack.spacing = 18
        detailsStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(detailsStack)
        NSLayoutConstraint.activate([
            detailsStack.topAnchor.constraint(equalTo: segmentBackground.bottomAnchor, constant: 24),
            detailsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            detailsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            detailsStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -24)
        ])
        
        setupOverviewContent()
        setupDetailsContent()
        
        // Set initial state
        showOverview()
    }
    
    private func setupOverviewContent() {
        overviewStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        overviewStack.addArrangedSubview(cardView(title: "Feasibility", value: "79% - High Potential", valueColor: .systemGreen, isBig: true))
        overviewStack.addArrangedSubview(cardView(title: "Estimated Time", value: "2 - 3 months"))
        overviewStack.addArrangedSubview(cardView(title: "Estimated Cost", value: "R$1,000 - R$3,000"))
        overviewStack.addArrangedSubview(cardView(title: "Target Audience", value: "Warm Leads"))
        
        // Key Recommendations
        let recTitle = UILabel()
        recTitle.text = "Key Recommendations"
        recTitle.font = UIFont.boldSystemFont(ofSize: 19)
        recTitle.translatesAutoresizingMaskIntoConstraints = false
        overviewStack.addArrangedSubview(recTitle)
        
        let recStack = UIStackView()
        recStack.axis = .vertical
        recStack.spacing = 4
        recStack.translatesAutoresizingMaskIntoConstraints = false
        [
            "Test different acquisition channels",
            "Conduct market research to validate interest",
            "Create an MVP to test the idea with real users"
        ].forEach { text in
            let label = UILabel()
            label.text = "• " + text
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = .secondaryLabel
            recStack.addArrangedSubview(label)
        }
        overviewStack.addArrangedSubview(recStack)
    }
    
    private func setupDetailsContent() {
        detailsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Strengths
        let strengthsTitle = UILabel()
        strengthsTitle.text = "Strengths"
        strengthsTitle.font = UIFont.boldSystemFont(ofSize: 19)
        detailsStack.addArrangedSubview(strengthsTitle)
        let strengthsStack = UIStackView()
        strengthsStack.axis = .vertical
        strengthsStack.spacing = 4
        [
            "Innovative potential",
            "Market opportunity",
            "Differentiation from competitors"
        ].forEach { text in
            let label = UILabel()
            label.text = "• " + text
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = .secondaryLabel
            strengthsStack.addArrangedSubview(label)
        }
        detailsStack.addArrangedSubview(strengthsStack)
        
        // Weaknesses
        let weaknessesTitle = UILabel()
        weaknessesTitle.text = "Weaknesses"
        weaknessesTitle.font = UIFont.boldSystemFont(ofSize: 19)
        detailsStack.addArrangedSubview(weaknessesTitle)
        let weaknessesStack = UIStackView()
        weaknessesStack.axis = .vertical
        weaknessesStack.spacing = 4
        [
            "High implementation cost",
            "High expectations",
            "Associated risks"
        ].forEach { text in
            let label = UILabel()
            label.text = "• " + text
            label.font = UIFont.systemFont(ofSize: 17)
            label.textColor = .secondaryLabel
            weaknessesStack.addArrangedSubview(label)
        }
        detailsStack.addArrangedSubview(weaknessesStack)
        
        // Contextual Analysis
        let contextTitle = UILabel()
        contextTitle.text = "Contextual Analysis"
        contextTitle.font = UIFont.boldSystemFont(ofSize: 19)
        detailsStack.addArrangedSubview(contextTitle)
        let contextLabel = UILabel()
        contextLabel.text = "This idea has market potential, but requires validation with real users before investing significant resources."
        contextLabel.font = UIFont.systemFont(ofSize: 17)
        contextLabel.textColor = .secondaryLabel
        contextLabel.numberOfLines = 0
        detailsStack.addArrangedSubview(contextLabel)
        
        // Suggested Next Steps
        let nextTitle = UILabel()
        nextTitle.text = "Suggested Next Steps"
        nextTitle.font = UIFont.boldSystemFont(ofSize: 19)
        detailsStack.addArrangedSubview(nextTitle)
        let nextLabel = UILabel()
        nextLabel.text = "We recommend proceeding with a structured implementation plan, starting with a prototype or MVP for initial validation."
        nextLabel.font = UIFont.systemFont(ofSize: 17)
        nextLabel.textColor = .secondaryLabel
        nextLabel.numberOfLines = 0
        detailsStack.addArrangedSubview(nextLabel)
    }
    
    // MARK: - Card View Helper
    private func cardView(title: String, value: String, valueColor: UIColor = .secondaryLabel, isBig: Bool = false) -> UIView {
        let card = UIView()
        card.backgroundColor = .secondarySystemBackground
        card.layer.cornerRadius = 18
        card.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 19)
        titleLabel.textColor = .labelsPrimary
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = isBig ? UIFont.boldSystemFont(ofSize: 26) : UIFont.systemFont(ofSize: 18)
        valueLabel.textColor = valueColor
        valueLabel.numberOfLines = 0
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .vertical
        stack.spacing = isBig ? 6 : 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),
            stack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -14)
        ])
        return card
    }
    
    // MARK: - Segmented Control Actions
    @objc private func showOverview() {
        isOverviewSelected = true
        
        UIView.animate(withDuration: 0.3) {
            self.overviewButton.backgroundColor = UIColor(named: "BackgroundsTertiary")
            self.overviewButton.setTitleColor(UIColor(named: "LabelsPrimary"), for: .normal)
            self.detailsButton.backgroundColor = .clear
            self.detailsButton.setTitleColor(.secondaryLabel, for: .normal)
            
            self.overviewStack.alpha = 1
            self.detailsStack.alpha = 0
            
            // Visual feedback
            self.overviewButton.layer.shadowColor = UIColor(named: "LabelsPrimary")?.withAlphaComponent(0.2).cgColor
            self.overviewButton.layer.shadowOpacity = 0.5
            self.overviewButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.overviewButton.layer.shadowRadius = 4
            self.detailsButton.layer.shadowOpacity = 0
        } completion: { _ in
            self.overviewStack.isHidden = false
            self.detailsStack.isHidden = true
        }
    }
    
    @objc private func showDetails() {
        isOverviewSelected = false
        
        UIView.animate(withDuration: 0.3) {
            self.overviewButton.backgroundColor = .clear
            self.overviewButton.setTitleColor(.secondaryLabel, for: .normal)
            self.detailsButton.backgroundColor = UIColor(named: "BackgroundsTertiary")
            self.detailsButton.setTitleColor(UIColor(named: "LabelsPrimary"), for: .normal)
            
            self.overviewStack.alpha = 0
            self.detailsStack.alpha = 1
            
            // Visual feedback
            self.detailsButton.layer.shadowColor = UIColor(named: "LabelsPrimary")?.withAlphaComponent(0.2).cgColor
            self.detailsButton.layer.shadowOpacity = 0.5
            self.detailsButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.detailsButton.layer.shadowRadius = 4
            self.overviewButton.layer.shadowOpacity = 0
        } completion: { _ in
            self.overviewStack.isHidden = true
            self.detailsStack.isHidden = false
        }
    }
} 
