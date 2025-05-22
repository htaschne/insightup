//
//  ModalAddInsightViewController.swift
//  insightup
//
//  Created by Eduardo Garcia Fensterseifer on 14/05/25.
//

import UIKit
import Foundation

// MARK: - UITextField Extension

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

// MARK: - ModalAddInsightDelegate Protocol
// Moved to ModalAddInsightProtocol.swift

class ModalAddInsightViewController: UIViewController, ViewCodeProtocol {
    
    // MARK: - Properties
    var onDone: ((Insight) -> Void)?
    weak var delegate: ModalAddInsightDelegate?
    private var editingInsight: Insight?
    private var defaultCategory: InsightCategory?
    
    // Selected values
    private var selectedCategory: InsightCategory = .Ideas
    private var selectedPriority: Category = .None
    private var selectedAudience: TargetAudience = .B2B
    private var selectedEffort: Effort = .Solo
    private var selectedBudget: Budget = .LessThan100
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - UserDefaults Keys
    private struct UserDefaultsKeys {
        static let selectedPriority = "SelectedPriority"
        static let selectedAudience = "SelectedAudience"
        static let selectedEffort = "SelectedEffort"
        static let selectedBudget = "SelectedBudget"
        static let lastUsedCategory = "LastUsedCategory"
    }
    
    lazy var navBar: UINavigationBar = {
        var navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.barTintColor = UIColor(named: "BackgroundsSecondary")
        navBar.isTranslucent = false
        
        let navItem = UINavigationItem()
        navItem.title = "Insight"
        
        let addButton = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(handleAdd(_:)))
        
        let cancelButton = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(handleCancel(_:)))
            
        navItem.rightBarButtonItem = addButton
        navItem.leftBarButtonItem = cancelButton
        
        navBar.setItems([navItem], animated: false)
        
        return navBar
    }()
    
    lazy var titleTextField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = UIColor(named: "LabelsPrimary")
        textField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        textField.textAlignment = .left
        textField.placeholder = "Title"
        textField.backgroundColor = UIColor(named: "BackgroundsTertiary")
        textField.layer.cornerRadius = 12
        textField.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textField.clipsToBounds = true
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        let rightPadding = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.rightView = rightPadding
        textField.rightViewMode = .always
        return textField
    }()
    
    lazy var notesTextView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = UIColor(named: "LabelsTertiary")
        textView.backgroundColor = UIColor(named: "BackgroundsTertiary")
        textView.layer.masksToBounds = true
        textView.text = "Notes"
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.delegate = self
        textView.layer.cornerRadius = 12
        textView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 9, bottom: 10, right: 9)
        return textView
    }()
    
    lazy var TitleNotesStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [titleTextField, notesTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    lazy var componentCategory: PropertiesSelector = {
        var component = PropertiesSelector()
        component.translatesAutoresizingMaskIntoConstraints = false
        component.configure(with:[
            PropertyItem(title: "Category", iconName: "tag.fill", options: ["Ideas", "Problems", "Feelings", "Observations"])
        ])
        return component
    }()

    lazy var componentDetails: PropertiesSelector = {
        var component = PropertiesSelector()
        component.translatesAutoresizingMaskIntoConstraints = false
        component.configure(with:[
            PropertyItem(
                    title: "Priority",
                    iconName: "exclamationmark.triangle.fill",
                    options: Category.allCases.map { $0.rawValue }
                ),
                PropertyItem(
                    title: "Audience",
                    iconName: "megaphone.fill",
                    options: TargetAudience.allCases.map { $0.rawValue }
                ),
                PropertyItem(
                    title: "Execution Effort",
                    iconName: "person.line.dotted.person.fill",
                    options: Effort.allCases.map { $0.rawValue }
                ),
                PropertyItem(
                    title: "Budget",
                    iconName: "dollarsign.gauge.chart.leftthird.topthird.rightthird",
                    options: Budget.allCases.map { $0.rawValue }
                )
        ])
        return component
    }()
    
    lazy var mainStack: UIStackView = {
        var stackView = UIStackView(arrangedSubviews: [TitleNotesStack, componentCategory, componentDetails])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()

    init(insight: Insight? = nil, defaultCategory: InsightCategory? = nil) {
        self.editingInsight = insight
        self.defaultCategory = defaultCategory
        super.init(nibName: nil, bundle: nil)
        
        // Configura os valores iniciais com base no insight existente ou nas preferências salvas
        if let insight = insight {
            // Se estiver editando um insight, usa os valores dele
            selectedCategory = insight.category
            selectedPriority = insight.priority
            selectedAudience = insight.audience
            selectedEffort = insight.executionEffort
            selectedBudget = insight.budget
        } else if let defaultCategory = defaultCategory {
            // Se houver uma categoria padrão, usa ela
            selectedCategory = defaultCategory
            // Carrega as preferências salvas
            loadSavedSelections()
        } else {
            // Tenta carregar a última categoria usada, se disponível
            loadSavedSelections()
            if let categoryRaw = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastUsedCategory),
               let category = InsightCategory(rawValue: categoryRaw) {
                selectedCategory = category
            }
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = .systemBackground
        titleTextField.setLeftPaddingPoints(12)
        componentCategory.delegate = self
        componentDetails.delegate = self
        notesTextView.delegate = self
        componentDetails.configure(with: [
            PropertyItem(
                title: "Priority",
                iconName: "exclamationmark.triangle.fill",
                options: Category.allCases.map { $0.rawValue }
            ),
            PropertyItem(
                title: "Audience",
                iconName: "megaphone.fill",
                options: TargetAudience.allCases.map { $0.rawValue }
            ),
            PropertyItem(
                title: "Execution Effort",
                iconName: "person.line.dotted.person.fill",
                options: Effort.allCases.map { $0.rawValue }
            ),
            PropertyItem(
                title: "Budget",
                iconName: "dollarsign.gauge.chart.leftthird.topthird.rightthird",
                options: Budget.allCases.map { $0.rawValue }
            )
        ])
        loadSavedSelections()
        if let insight = editingInsight {
            titleTextField.text = insight.title
            notesTextView.text = insight.notes.isEmpty ? "Notes" : insight.notes
            notesTextView.textColor = insight.notes.isEmpty ? UIColor(named: "LabelsTertiary") : UIColor(named: "LabelsPrimary")
            selectedCategory = insight.category
            selectedPriority = insight.priority
            selectedAudience = insight.audience
            selectedEffort = insight.executionEffort
            selectedBudget = insight.budget
        }
        updateUI()
    }
    
    private func loadSavedSelections() {
        let defaults = UserDefaults.standard
        
        if let priorityRaw = defaults.string(forKey: UserDefaultsKeys.selectedPriority),
           let priority = Category(rawValue: priorityRaw) {
            selectedPriority = priority
        }
        
        if let audienceRaw = defaults.string(forKey: UserDefaultsKeys.selectedAudience),
           let audience = TargetAudience(rawValue: audienceRaw) {
            selectedAudience = audience
        }
        
        if let effortRaw = defaults.string(forKey: UserDefaultsKeys.selectedEffort),
           let effort = Effort(rawValue: effortRaw) {
            selectedEffort = effort
        }
        
        if let budgetRaw = defaults.string(forKey: UserDefaultsKeys.selectedBudget),
           let budget = Budget(rawValue: budgetRaw) {
            selectedBudget = budget
        }
        
        if let categoryRaw = defaults.string(forKey: UserDefaultsKeys.lastUsedCategory),
           let category = InsightCategory(rawValue: categoryRaw) {
            selectedCategory = category
        } else if let defaultCategory = defaultCategory {
            selectedCategory = defaultCategory
        }
    }
    
    private func updateUI() {
        // Update category selector
        componentCategory.setSelectedValue(selectedCategory.rawValue, for: "Category")
        
        // Update details selectors
        componentDetails.setSelectedValue(selectedPriority.rawValue, for: "Priority")
        componentDetails.setSelectedValue(selectedAudience.rawValue, for: "Audience")
        componentDetails.setSelectedValue(selectedEffort.rawValue, for: "Execution Effort")
        componentDetails.setSelectedValue(selectedBudget.rawValue, for: "Budget")
    }
    
    private func saveSelections() {
        let defaults = UserDefaults.standard
        defaults.set(selectedPriority.rawValue, forKey: UserDefaultsKeys.selectedPriority)
        defaults.set(selectedAudience.rawValue, forKey: UserDefaultsKeys.selectedAudience)
        defaults.set(selectedEffort.rawValue, forKey: UserDefaultsKeys.selectedEffort)
        defaults.set(selectedBudget.rawValue, forKey: UserDefaultsKeys.selectedBudget)
        defaults.set(selectedCategory.rawValue, forKey: UserDefaultsKeys.lastUsedCategory)
    }
    
    @objc private func handleCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc private func handleAdd(_ sender: UIBarButtonItem) {
        // Validate title
        guard let title = titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty else {
            showAlert(title: "Missing Title", message: "Please enter a title for your insight.")
            return
        }
        
        // Get notes, checking if it's the default text
        let notes = (notesTextView.text == "Notes" || notesTextView.text.isEmpty) ? "" : notesTextView.text ?? ""
        
        // Save current selections for future use
        saveSelections()
        
        // Create or update the insight
        let insight = Insight(
            id: editingInsight?.id ?? UUID(),
            title: title,
            notes: notes,
            category: selectedCategory,
            priority: selectedPriority,
            audience: selectedAudience,
            executionEffort: selectedEffort,
            budget: selectedBudget,
            createdAt: editingInsight?.createdAt ?? Date(),
            updatedAt: Date()
        )
        
        if editingInsight != nil {
            // Update existing insight
            _ = InsightPersistence.updateInsight(updatedInsight: insight)
            delegate?.didUpdateInsight(insight)
            onDone?(insight)
        } else {
            // Add new insight
            var allInsights = InsightPersistence.getAll()
            allInsights.insights.append(insight)
            InsightPersistence.save(insights: allInsights)
            delegate?.didAddInsight(insight)
            onDone?(insight)
        }
        
        // Notify about the change
        NotificationCenter.default.post(name: NSNotification.Name("InsightsDidChange"), object: nil)
        
        // Close the screen
        dismiss(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        // Remove keyboard notification observers
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - ViewCodeProtocol
    
    func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(navBar)
        contentView.addSubview(mainStack)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Nav Bar
            navBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // Main Stack
            mainStack.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
        
        // Fixed heights
        componentCategory.heightAnchor.constraint(equalToConstant: 51).isActive = true
        componentDetails.heightAnchor.constraint(equalToConstant: 255).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: 51).isActive = true
        notesTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupView() {
        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, 
                                           selector: #selector(handleKeyboardWillShow(_:)), 
                                           name: UIResponder.keyboardWillShowNotification, 
                                           object: nil)
        NotificationCenter.default.addObserver(self, 
                                           selector: #selector(handleKeyboardWillHide(_:)), 
                                           name: UIResponder.keyboardWillHideNotification, 
                                           object: nil)
    }
    
    func setupKeyboardDismissal() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Keyboard Handling
    
    @discardableResult
    private func findFirstResponder(in view: UIView? = nil) -> UIView? {
        let searchView = view ?? self.view ?? UIView()
        
        if searchView.isFirstResponder {
            return searchView
        }
        
        for subview in searchView.subviews {
            if let firstResponder = findFirstResponder(in: subview) {
                return firstResponder
            }
        }
        
        return nil
    }
    
    @objc private func handleKeyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height - view.safeAreaInsets.bottom, right: 0)
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve << 16)) { [weak self] in
            self?.scrollView.contentInset = contentInsets
            self?.scrollView.scrollIndicatorInsets = contentInsets
            
            // Scroll to the active text field if needed
            if let activeField = self?.findFirstResponder(),
               let scrollView = self?.scrollView {
                let rect = activeField.convert(activeField.bounds, to: scrollView)
                scrollView.scrollRectToVisible(rect, animated: true)
            }
        }
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        let activeField: UIView? = [titleTextField, notesTextView].first { $0.isFirstResponder }
        
        if let activeField = activeField {
            var aRect = view.frame
            aRect.size.height -= keyboardSize.height
            
            if !aRect.contains(activeField.frame.origin) {
                let scrollPoint = CGPoint(x: 0, y: activeField.frame.origin.y - keyboardSize.height)
                scrollView.setContentOffset(scrollPoint, animated: true)
            }
        }
    }
    
    @objc private func handleKeyboardWillHide(_ notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        
        let contentInsets = UIEdgeInsets.zero
        
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve << 16)) { [weak self] in
            self?.scrollView.contentInset = contentInsets
            self?.scrollView.scrollIndicatorInsets = contentInsets
        }
    }
}

// MARK: - PropertiesSelectorDelegate

extension ModalAddInsightViewController: PropertiesSelectorDelegate {
    func propertiesSelector(_ selector: PropertiesSelector, didSelectItemAt indexPath: IndexPath) {
        // Handle item selection if needed
    }
    
    func propertiesSelector(_ selector: PropertiesSelector, didSelectValue value: String, forProperty property: String) {
        // Update the selected value based on the property
        switch property {
        case "Category":
            if let category = InsightCategory(rawValue: value) {
                selectedCategory = category
                // Save the selected category for future use
                UserDefaults.standard.set(selectedCategory.rawValue, forKey: UserDefaultsKeys.lastUsedCategory)
            }
        case "Priority":
            if let priority = Category(rawValue: value) {
                selectedPriority = priority
                UserDefaults.standard.set(selectedPriority.rawValue, forKey: UserDefaultsKeys.selectedPriority)
            }
        case "Audience":
            if let audience = TargetAudience(rawValue: value) {
                selectedAudience = audience
                UserDefaults.standard.set(selectedAudience.rawValue, forKey: UserDefaultsKeys.selectedAudience)
            }
        case "Execution Effort":
            if let effort = Effort(rawValue: value) {
                selectedEffort = effort
                UserDefaults.standard.set(selectedEffort.rawValue, forKey: UserDefaultsKeys.selectedEffort)
            }
        case "Budget":
            if let budget = Budget(rawValue: value) {
                selectedBudget = budget
                UserDefaults.standard.set(selectedBudget.rawValue, forKey: UserDefaultsKeys.selectedBudget)
            }
        default:
            break
        }
    }
}

// MARK: - UITextViewDelegate

extension ModalAddInsightViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Notes" {
            textView.text = ""
            textView.textColor = UIColor(named: "LabelsPrimary")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = UIColor(named: "LabelsTertiary")
        }
    }
}
