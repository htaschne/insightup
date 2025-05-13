//
//  ViewCodeProtocol.swift
//  insightup
//
//  Created by Agatha Schneider on 13/05/25.
//

protocol ViewCodeProtocol {
    func addSubviews()
    func addConstraints()
    func setup()
}

extension ViewCodeProtocol {
    func setup() {
        addSubviews()
        addConstraints()
    }
}
