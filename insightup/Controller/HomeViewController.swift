//
//  ViewController.swift
//  insightup
//
//  Created by Agatha Schneider on 12/05/25.
//

import UIKit
import DesignSystem

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO(Agatha): make color conform to figma, shouldn't be hardcoded
        view.backgroundColor = UIColor(hex: "#F2F2F2")
        navigationController?.navigationBar.backgroundColor = UIColor(hex: "#F2F2F2")
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "InsightUp"
    }


}

extension HomeViewController: ViewCodeProtocol {
    func addSubviews() {
        [
        ].forEach({ view.addSubview($0) })
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            
        ])
    }
}
