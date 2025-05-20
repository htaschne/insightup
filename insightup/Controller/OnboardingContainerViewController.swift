//
//  OnboardingContainerViewController.swift
//  insightup
//
//  Created by Enzo Tonatto on 15/05/25.
//

import UIKit

class OnboardingContainerViewController: UIViewController {
    // MARK: Data
    private var onBoardingData: OnboardingData

    // MARK: UI
    private let progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .bar)
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.trackTintColor = UIColor.colorsBlue.withAlphaComponent(0.3)
        pv.progressTintColor = UIColor.colorsBlue
        pv.progress = 0.2
        pv.transform = CGAffineTransform(scaleX: 1, y: 16)
        pv.clipsToBounds = true
        pv.layer.cornerRadius = 8
        return pv
    }()

    // MARK: Pages
    private lazy var pages: [OnboardingPage] = [
          // 1) Tela de boas-vindas (info)
          OnboardingPage(
            title: "Welcome to InsightUp!",
            description: "Efficiently capture, organize and develop your ideas, problems, feelings and observations.",
            imageName: "OnboardingImage",
            type: .info,
            buttonTitle: "Continue"
          ),

          // 2) Rotina semanal (single choice)
          OnboardingPage(
            title: "What does your weekly routine look like?",
            description: "This helps us personalize reminders and insights based on your lifestyle.",
            imageName: "",
            type: .singleChoice(
              options: [
                (title: "Only free on weekends",   subtitle: "Weekdays are packed."),
                (title: "Some free hours during the week", subtitle: "Quick breaks here and there."),
                (title: "A few free days a week",  subtitle: "2–3 days with more time."),
                (title: "Plenty of free time",     subtitle: "Lots of time to reflect.")
              ],
              onSelect: { [weak self] idx in
                let routines: [OnboardingData.WeeklyRoutine] = [
                  .onlyWeekends,
                  .someWeekHours,
                  .fewFreeDays,
                  .plentyFreeTime
                ]
                self?.onBoardingData.routine = routines[idx]
              }
            ),
            buttonTitle: "Continue"
          ),

          // 3) Áreas de interesse (multi choice)
          OnboardingPage(
            title: "What are your areas of interest?",
            description: "Select the areas that interest you most to help us organize your insights.",
            imageName: "",
            type: .multiChoice(
              options: [
                "Business", "Health", "Technology", "Education",
                "Art", "Finance", "Personal", "Others"
              ],
              onSelect: { [weak self] indices in
                let allInterests: [OnboardingData.Interest] = [
                  .business, .health, .technology, .education,
                  .art, .finance, .personalDevelopment, .others
                ]
                self?.onBoardingData.interests = indices.map { allInterests[$0] }
              }
            ),
            buttonTitle: "Continue"
          ),

          // 4) Objetivo principal (multi choice)
          OnboardingPage(
            title: "What’s your main goal right now?",
            description: "Knowing your goals helps us make more relevant recommendations.",
            imageName: "",
            type: .multiChoice(
              options: [
                "Solve problems",
                "Generate new ideas",
                "Organize thoughts",
                "Develop projects",
                "Improve productivity"
              ],
              onSelect: { [weak self] indices in
                let goals: [OnboardingData.MainGoal] = [
                  .solveProblems,
                  .generateIdeas,
                  .organizeThoughts,
                  .developProjects,
                  .improveProductivity
                ]
                  self?.onBoardingData.mainGoals = indices.map { goals[$0] }
              }
            ),
            buttonTitle: "Continue"
          ),

          // 5) Tela de encerramento (info)
          OnboardingPage(
            title: "All set, ready to grow!",
            description: "Capture insights, spark ideas, act with        AI-powered clarity.",
            imageName: "LampImage",
            type: .info,
            buttonTitle: "Launch Insight"
          )
        ]
    private var currentIndex: Int = 0 {
        didSet {
            updateProgress(animated: true)
        }
    }

    private lazy var pageViewController: UIPageViewController = {
        let pvc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pvc.dataSource = self
        pvc.delegate = self
        return pvc
    }()

    // MARK: Init
    init() {
        self.onBoardingData = UserDefaults.standard.loadOnboarding() ?? OnboardingData()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        self.onBoardingData = UserDefaults.standard.loadOnboarding() ?? OnboardingData()
        super.init(coder: coder)
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
        showPage(at: 0, direction: .forward, animated: false)
        updateProgress(animated: false)
    }

    // Atualiza a barra de progresso
    private func updateProgress(animated: Bool) {
        guard pages.count > 1 else {
            progressView.setProgress(1, animated: animated)
            return
        }
        let progress = Float(currentIndex + 1) / Float(pages.count)
        progressView.setProgress(progress, animated: animated)
    }

    // Cria o contentVC e configura o botão de avançar
    private func makeContentVC(at index: Int) -> OnboardingContentViewController {
        let contentVC = OnboardingContentViewController(page: pages[index])
        
        contentVC.buttonAction = { [weak self] in
            guard let self = self else { return }
            if index + 1 < self.pages.count {
                self.showPage(at: index + 1, direction: .forward, animated: true)
            } else {
                self.finishOnboarding()
            }
        }

        contentVC.skipAction = { [weak self] in
            guard let self = self else { return }
            let lastIndex = self.pages.count - 1
            self.showPage(at: lastIndex, direction: .forward, animated: true)
        }

        return contentVC
    }

    private func showPage(at index: Int,
                          direction: UIPageViewController.NavigationDirection,
                          animated: Bool) {
        let vc = makeContentVC(at: index)
        pageViewController.setViewControllers([vc],
                                              direction: direction,
                                              animated: animated,
                                              completion: nil)
        currentIndex = index
    }

    private func finishOnboarding() {
        onBoardingData.isComplete = true
        UserDefaults.standard.saveOnboarding(onBoardingData)

        SceneDelegate.shared?.switchToHome()
    }


}

// MARK: UIPageViewControllerDataSource
extension OnboardingContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pvc: UIPageViewController,
                             viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard currentIndex > 0 else { return nil }
        return makeContentVC(at: currentIndex - 1)
    }

    func pageViewController(_ pvc: UIPageViewController,
                             viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard currentIndex + 1 < pages.count else { return nil }
        return makeContentVC(at: currentIndex + 1)
    }
}

// MARK: UIPageViewControllerDelegate
extension OnboardingContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pvc: UIPageViewController,
                             didFinishAnimating _: Bool,
                             previousViewControllers _: [UIViewController],
                             transitionCompleted completed: Bool) {
        guard completed,
              let visible = pvc.viewControllers?.first as? OnboardingContentViewController,
              let idx = pages.firstIndex(where: { $0.title == visible.page.title })
        else { return }
        currentIndex = idx
    }
}

// MARK: ViewCodeProtocol
extension OnboardingContainerViewController: ViewCodeProtocol {
    func addSubviews() {
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        view.addSubview(progressView)
    }

    func addConstraints() {
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            pageViewController.view.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 64),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
    }
}
