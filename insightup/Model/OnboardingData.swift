//
//  OnboardingData.swift
//  insightup
//
//  Created by Enzo Tonatto on 15/05/25.
//

struct OnboardingData: Codable {
    enum WeeklyRoutine: String, Codable, CaseIterable {
            case onlyWeekends
            case someWeekHours
            case fewFreeDays
            case plentyFreeTime

            var description: String {
                switch self {
                case .onlyWeekends:
                    return "Only on weekends"
                case .someWeekHours:
                    return "Some hours during the week"
                case .fewFreeDays:
                    return "A few free days"
                case .plentyFreeTime:
                    return "Plenty of free time"
                }
            }
        }
    enum Interest: String, Codable, CaseIterable {
        case business
        case health
        case technology
        case education
        case art
        case finance
        case personalDevelopment
        case others

        var description: String {
            switch self {
            case .business: return "Business"
            case .health: return "Health"
            case .technology: return "Technology"
            case .education: return "Education"
            case .art: return "Art"
            case .finance: return "Finance"
            case .personalDevelopment: return "Personal Development"
            case .others: return "Others"
            }
        }
    }

    enum MainGoal: String, Codable, CaseIterable {
        case solveProblems
        case generateIdeas
        case organizeThoughts
        case developProjects
        case improveProductivity

        var description: String {
            switch self {
            case .solveProblems: return "Solve problems"
            case .generateIdeas: return "Generate ideas"
            case .organizeThoughts: return "Organize thoughts"
            case .developProjects: return "Develop projects"
            case .improveProductivity: return "Improve productivity"
            }
        }
    }

    
    var routine: WeeklyRoutine?
    var interests: [Interest] = []
    var mainGoals: [MainGoal] = []
    var isComplete: Bool = false
}
