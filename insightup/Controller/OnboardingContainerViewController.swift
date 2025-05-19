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
    
    init() {
        self.onBoardingData = UserDefaults.standard.loadOnboarding()
          ?? OnboardingData()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Subviews
    private let pageControl = UIPageControl()
    
    // MARK: Page
    private lazy var pages: [OnboardingPage] = [
      // 1) Tela de boas-vindas (info)
      OnboardingPage(
        title: "Welcome to InsightUp!",
        description: "Efficiently capture, organize and develop your ideas, problems, feelings and observations.",
        type: .info,
        buttonTitle: "Continue"
      ),

      // 2) Rotina semanal (single choice)
      OnboardingPage(
        title: "What does your weekly routine look like?",
        description: "This helps us personalize reminders and insights based on your lifestyle.",
        type: .singleChoice(
          options: [
            (title: "Only free on weekends",   subtitle: "Weekdays are packed."),
            (title: "Some free hours during…", subtitle: "Quick breaks here and there."),
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
        description: "Capture insights, spark ideas, act with AI-powered clarity.",
        type: .info,
        buttonTitle: "Launch Insight"
      )
    ]
    
    private var currentIndex = 0 {
        didSet {
            pageControl.currentPage = currentIndex
        }
    }
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageViewController.dataSource = self
        pageViewController.delegate = self
        return pageViewController
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setup()
        setupPageControl()
        showPage(at: 0, direction: .forward, animated: false)
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: Helpers
    private func makeContentVC(at index: Int) -> OnboardingContentViewController {
        let contentVC = OnboardingContentViewController(page: pages[index])
        
        contentVC.buttonAction = { [weak self] in
            guard let self = self else { return }
            if index + 1 < self.pages.count {
                self.showPage(at: index + 1, direction: .forward, animated: true)
            } else {
                self.finsishOnboarding()
            }
        }
        
        return contentVC
    }
    
    private func showPage(at index: Int, direction: UIPageViewController.NavigationDirection, animated: Bool) {
        let vc = makeContentVC(at: index)
        pageViewController.setViewControllers([vc], direction: direction, animated: animated, completion: nil)
        currentIndex = index
    }
    
    private func finsishOnboarding() {
//        UserDefaults.standard.saveOnboarding(onBoardingData)
//        let home = HomeViewController(onBoardingData: onBoardingData)
//        UIApplication.shared.windows.first?.rootViewController = home
        
        print("Routine: \(String(describing: onBoardingData.routine))")
        print("Interests: \(onBoardingData.interests.map { $0.rawValue })")
        print("MainGoals: \(onBoardingData.mainGoals.map { $0.rawValue })")
    }
}

extension OnboardingContainerViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard currentIndex > 0 else { return nil }
        return makeContentVC(at: currentIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard currentIndex + 1 < pages.count else { return nil }
        return makeContentVC(at: currentIndex + 1)
    }
    
    
}

extension OnboardingContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pvc: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
        guard completed,
              let visible = pvc.viewControllers?.first as? OnboardingContentViewController,
              let idx = pages.firstIndex(where: { $0.title == visible.page.title })
        else { return }
        currentIndex = idx
    }
}

extension OnboardingContainerViewController: ViewCodeProtocol {
    func addSubviews() {
        addChild(pageViewController)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false  
        view.addSubview(pageControl)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
