//
//  UserDefaultsOnBoarding.swift
//  insightup
//
//  Created by Enzo Tonatto on 15/05/25.
//

import Foundation

extension UserDefaults {
  private static let onboardingKey = "onboarding_data"

  func saveOnboarding(_ data: OnboardingData) {
    if let encoded = try? JSONEncoder().encode(data) {
      set(encoded, forKey: Self.onboardingKey)
    }
  }

  func loadOnboarding() -> OnboardingData? {
    guard let raw = data(forKey: Self.onboardingKey),
          let decoded = try? JSONDecoder().decode(OnboardingData.self, from: raw)
    else { return nil }
    return decoded
  }
}


