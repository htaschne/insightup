//
//  SplashScreenViewController.swift
//  insightup
//
//  Created by Enzo Tonatto on 21/05/25.
//

import UIKit

class SplashScreenViewController: UIViewController {

    private let lampOffImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LampOffImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.1
        return imageView
    }()

    private let lampOnImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LampImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.0
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "InsightUp"
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .graysBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.1
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        view.addSubview(lampOffImageView)
        view.addSubview(lampOnImageView)
        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            lampOffImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lampOffImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            lampOffImageView.widthAnchor.constraint(equalToConstant: 160),
            lampOffImageView.heightAnchor.constraint(equalToConstant: 160),

            lampOnImageView.centerXAnchor.constraint(equalTo: lampOffImageView.centerXAnchor),
            lampOnImageView.centerYAnchor.constraint(equalTo: lampOffImageView.centerYAnchor),
            lampOnImageView.widthAnchor.constraint(equalTo: lampOffImageView.widthAnchor),
            lampOnImageView.heightAnchor.constraint(equalTo: lampOffImageView.heightAnchor),

            titleLabel.topAnchor.constraint(equalTo: lampOffImageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 2.0, animations: {
            self.lampOnImageView.alpha = 1.0
            self.lampOffImageView.alpha = 0.0
            self.titleLabel.alpha = 1.0
            self.titleLabel.textColor = .graysBlack
            self.view.backgroundColor = .white
            
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                UIView.animate(withDuration: 1.0, animations: {
                    self.view.alpha = 0.0
                }, completion: { _ in
                    let nextVC: UIViewController
                    if let onboarding = UserDefaults.standard.loadOnboarding(), onboarding.isComplete {
                        nextVC = HomeViewController()
                    } else {
                        nextVC = OnboardingContainerViewController()
                    }

                    let nav = UINavigationController(rootViewController: nextVC)
                    nav.modalPresentationStyle = .fullScreen
                    nav.modalTransitionStyle = .crossDissolve
                    self.view.window?.rootViewController = nav
                })
            }

        })
    }
}
