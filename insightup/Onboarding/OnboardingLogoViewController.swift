import UIKit

class OnboardingLogoViewController: UIViewController {
    private let lampImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bulb_on"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "InsightUp"
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1, alpha: 1)
        view.addSubview(lampImageView)
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            lampImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lampImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            lampImageView.widthAnchor.constraint(equalToConstant: 160),
            lampImageView.heightAnchor.constraint(equalToConstant: 160),
            titleLabel.topAnchor.constraint(equalTo: lampImageView.bottomAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        // Simula um loading e vai para a Home após 1.5s
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let homeVC = HomeViewController()
            let nav = UINavigationController(rootViewController: homeVC)
            nav.modalTransitionStyle = .crossDissolve
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
} 
