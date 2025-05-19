import UIKit

class OnboardingSplashViewController: UIViewController {
    private let lampOffImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bulb_off"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.1
        return imageView
    }()
    private let lampOnImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bulb_on"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.0 // Começa invisível
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "InsightUp"
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = UIColor(white: 1, alpha: 0.1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0.1
        return label
    }()
    private let turnOnButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Turn on", for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 0.65, blue: 0, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(lampOffImageView)
        view.addSubview(lampOnImageView)
        view.addSubview(titleLabel)
        view.addSubview(turnOnButton)
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
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            turnOnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            turnOnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            turnOnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            turnOnButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        turnOnButton.addTarget(self, action: #selector(turnOnTapped), for: .touchUpInside)
    }
    @objc private func turnOnTapped() {
        UIView.animate(withDuration: 0.7, animations: {
            self.lampOnImageView.alpha = 1.0
            self.lampOffImageView.alpha = 0.0
            self.titleLabel.alpha = 1.0
            self.titleLabel.textColor = .white
        }, completion: { _ in
            self.turnOnButton.isHidden = true
            // Agora apresenta a tela clara com a lâmpada acesa
            let logoVC = OnboardingLogoViewController()
            logoVC.modalTransitionStyle = .crossDissolve
            logoVC.modalPresentationStyle = .fullScreen
            self.present(logoVC, animated: true)
        })
    }
} 
