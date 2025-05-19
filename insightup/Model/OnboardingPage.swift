//
//  OnboardingPage.swift
//  insightup
//
//  Created by Enzo Tonatto on 15/05/25.
//

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String?
    let type: OnboardingPageType
    let buttonTitle: String?
}

enum OnboardingPageType {
    case info
    case singleChoice(
        options: [(title: String, subtitle: String)],
        onSelect: (Int) -> Void
    )
    case multiChoice(options: [String],
                     onSelect: ([Int]) -> Void)
}
