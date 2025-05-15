//
//  ModalAddInsightViewController.swift
//  insightup
//
//  Created by Eduardo Garcia Fensterseifer on 14/05/25.
//

import UIKit

class ModalAddInsightViewController: UIViewController {
    
    var onDone: (() -> Void)?
    
    lazy var navBar: UINavigationBar = {
        var navBar = UINavigationBar()
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.barTintColor = UIColor(named: "BackgroundsSecondary")
        navBar.isTranslucent = false
        
        let navItem = UINavigationItem()
        navItem.title = "Insight"
        
        navItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(handleAdd))
        
        navItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(handleCancel))
        
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
            PropertyItem(title: "Priority", iconName: "exclamationmark.triangle.fill", options: ["Ideas", "Problems", "Feelings", "Observations"]),
            PropertyItem(title: "Audience", iconName: "megaphone.fill", options: ["Ideas", "Problems", "Feelings", "Observations"]),
            PropertyItem(title: "Execution Effort", iconName: "person.line.dotted.person.fill", options: ["Ideas", "Problems", "Feelings", "Observations"]),
            PropertyItem(title: "Budget", iconName: "dollarsign.gauge.chart.leftthird.topthird.rightthird", options: ["Ideas", "Problems", "Feelings", "Observations"])
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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "BackgroundsSecondary")
        setup()
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc func handleAdd() {
                
//      MARK: Implementar a funcionalidade de adicão de Insight aqui!
        
        print("Button Add Pressed - from navBar !!!!!")
        
        dismiss(animated: true) {
            self.onDone?()
        }
    }

}

extension ModalAddInsightViewController: ViewCodeProtocol {
    
    func addSubviews() {
        view.addSubview(navBar)
        view.addSubview(mainStack)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),
            
            mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            componentCategory.heightAnchor.constraint(equalToConstant: 51),
            componentDetails.heightAnchor.constraint(equalToConstant: 207),

            titleTextField.heightAnchor.constraint(equalToConstant: 52),
            notesTextView.heightAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
}

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
