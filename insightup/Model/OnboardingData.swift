//
//  OnboardingData.swift
//  insightup
//
//  Created by Enzo Tonatto on 15/05/25.
//

struct OnboardingData: Codable {
    enum WeeklyRoutine: String, Codable, CaseIterable {
            case onlyWeekends = "Only on weekends"
            case someWeekHours = "Some hours during the week"
            case fewFreeDays = "A few free days"
            case plentyFreeTime = "Plenty of free time"

        var description: String { rawValue }
        }
    
    enum Interest: String, Codable, CaseIterable {
        case business = "Business"
        case health = "Health"
        case technology = "Technology"
        case education = "Education"
        case art = "Art"
        case finance = "Finance"
        case personalDevelopment = "Personal Development"
        case others = "Others"

        var description: String { rawValue }
        
    }

    enum MainGoal: String, Codable, CaseIterable {
        case solveProblems = "Solve problems"
        case generateIdeas = "Generate ideas"
        case organizeThoughts = "Organize thoughts"
        case developProjects = "Develop projects"
        case improveProductivity = "Improve productivity"

        var description: String { rawValue }
    }

    
    var routine: WeeklyRoutine?
    var interests: [Interest] = []
    var mainGoals: [MainGoal] = []
    var isComplete: Bool = false
}
