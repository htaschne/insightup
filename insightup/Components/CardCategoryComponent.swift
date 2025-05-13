//
//  CardCategoryComponent.swift
//  insightup
//
//  Created by Eduardo Garcia Fensterseifer on 13/05/25.
//

import UIKit

class CardCategoryComponent: UIView {
    
    lazy var icon: UIImageView = {
        
        var imageView = UIImageView(image: UIImage(named: "Ideas"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 17
        imageView.clipsToBounds = true
        
        imageView.setContentHuggingPriority(UILayoutPriority(800), for: .horizontal)
        
        return imageView
    }()
    
    var iconImage: UIImage? {
        didSet {
            icon.image = iconImage
        }
    }
    
    lazy var counter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "Label-Primary")
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .right
        label.text = "1"
        return label
    }()
    
    var counterValue: String? {
        didSet {
            counter.text = counterValue
        }
    }
    
    lazy var iconCounterStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [icon, counter])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "GraysGray")
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.text = "Ideas"
        return label
    }()
    
    var componentTitle: String? {
        didSet {
            title.text = componentTitle
        }
    }
    
    lazy var fullStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconCounterStack, title])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 11
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "Background-Tertiary")
        self.layer.cornerRadius = 12
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CardCategoryComponent: ViewCodeProtocol {
    
    func addSubviews() {
        addSubview(fullStack)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            
            fullStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            fullStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            fullStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            fullStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
//            fullStack.heightAnchor.constraint(equalToConstant: 44),
            
            icon.widthAnchor.constraint(equalToConstant: 34),
            icon.heightAnchor.constraint(equalToConstant: 34),
            
        ])
    }
}
