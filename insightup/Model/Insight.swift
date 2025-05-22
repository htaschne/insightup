//
//  Insight.swift
//  insightup
//
//  Created by Agatha Schneider on 13/05/25.
//

import Foundation
import UIKit

enum InsightCategory: String, Codable, CaseIterable {
    case Ideas, Problems, Feelings, Observations, All
    
    var imageName: String {
        [
            .Ideas: "lightbulb.fill",
            .Problems: "exclamationmark.bubble.fill",
            .Feelings: "heart.fill",
            .Observations: "eye.fill",
            .All: "tray.fill",
        ][self, default: "ellipsis"]
    }
    
    var color: UIColor {
        [
            .Ideas: UIColor(named: "ColorsYellow")!,
            .Feelings: UIColor(named: "ColorsRed")!,
            .Problems: UIColor(named: "ColorsBlue")!,
            .Observations: UIColor(named: "ColorsGreen")!,
        ][self, default: .gray]
    }
}

enum Category: String, Codable, CaseIterable {
    case High, Medium, Low, None
}

enum TargetAudience: String, Codable, CaseIterable {
    case B2B, B2C, B2B2C, B2E, B2G, C2C, D2D, None
}

enum Budget: String, Codable, CaseIterable {
    case LessThan100 = "Less than $100"
    case Between100And500 = "$100 – $500"
    case Between500And1000 = "$500 – $1000"
    case MoreThan1000 = "More than $1000"

    var description: String { rawValue }
}


enum Effort: String, Codable, CaseIterable {
    case Solo = "Solo"
    case With1 = "With 1 other"
    case With2to4 = "2–4 people"
    case CrossTeam = "Cross-team +4"
    case ExternalHelp = "External help"
    case None = "None"

    var description: String { rawValue }
}


struct Insight: Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var notes: String
    var category: InsightCategory = .All
    var priority: Category = .None
    var audience: TargetAudience = .None
//    var impact: Category
    var executionEffort: Effort = .None
    var bugdet: Budget = .LessThan100
}

struct Insights: Codable {
    var insights: [Insight]
}

struct PropertyItem {
    let title: String
    let iconName: String
    let options: [String]
    var selectedOptionIndex: Int? = nil
    var selectedOptions: [String]
    let multipleSelection: Bool
}

extension Category {
    var sortOrder: Int {
        switch self {
        case .High: return 0
        case .Medium: return 1
        case .Low: return 2
        case .None: return 3
        }
    }
}

extension Budget {
    var sortOrder: Int {
        switch self {
        case .LessThan100: return 0
        case .Between100And500: return 1
        case .Between500And1000: return 2
        case .MoreThan1000: return 3
        }
    }
}

extension Effort {
    var sortOrder: Int {
        switch self {
        case .Solo: return 0
        case .With1: return 1
        case .With2to4: return 2
        case .CrossTeam: return 3
        case .ExternalHelp: return 4
        case .None: return 5
        }
    }

}
