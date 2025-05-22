//
//  ProfileComponent.swift
//  insightup
//
//  Created by Fernando Sulzbach on 22/05/25.
//

import UIKit

class ProfileComponent: UIView {
    
    private lazy var imgProfilePicture: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "ProfileImage")
        imgView.tintColor = .systemGray
        return imgView
    }()
    
    private lazy var labelUserName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Leonardo Simon Monteiro"
        label.textColor = UIColor(named: "LabelsPrimary")
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var labelUserFooter: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Apple Account, iCloud+, and more"
        label.numberOfLines = 3
        label.textColor = UIColor(named: "LabelsSecondary")
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var stackUserName: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [labelUserName, labelUserFooter])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "BackgroundsTertiary")
        self.layer.cornerRadius = 12
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

extension ProfileComponent: ViewCodeProtocol {
    func addSubviews() {
        addSubview(imgProfilePicture)
        addSubview(stackUserName)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            
            imgProfilePicture.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            imgProfilePicture.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            imgProfilePicture.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            imgProfilePicture.heightAnchor.constraint(equalToConstant: 54),
            imgProfilePicture.widthAnchor.constraint(equalToConstant: 54),
            
            stackUserName.topAnchor.constraint(equalTo: self.topAnchor, constant: 17),
            stackUserName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -17),
            stackUserName.leadingAnchor.constraint(equalTo: imgProfilePicture.trailingAnchor, constant: 10),
            stackUserName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            stackUserName.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
}
