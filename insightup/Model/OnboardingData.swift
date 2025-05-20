//
//  OnboardingData.swift
//  insightup
//
//  Created by Enzo Tonatto on 15/05/25.
//

struct OnboardingData: Codable {
    enum WeeklyRoutine: String, Codable, CaseIterable {
        case onlyWeekends, someWeekHours, fewFreeDays, plentyFreeTime
    }
    enum Interest: String, Codable, CaseIterable {
        case business, health, technology, education, art, finance, personalDevelopment, others
    }
    enum MainGoal: String, Codable, CaseIterable {
        case solveProblems, generateIdeas, organizeThoughts, developProjects, improveProductivity
    }
    
    var routine: WeeklyRoutine?
    var interests: [Interest] = []
    var mainGoals: [MainGoal] = []
}
