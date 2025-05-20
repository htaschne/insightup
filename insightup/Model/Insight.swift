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
            .All: "ellipsis",
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
    case B2B, B2C, B2B2C, B2E, B2G, C2C, D2D
}

enum Budget: String, Codable, CaseIterable {
    case LessThan100
    case Between100And500
    case Between500And1000
    case MoreThan1000

    var description: String {
        switch self {
        case .LessThan100: return "Less than $100"
        case .Between100And500: return "$100 – $500"
        case .Between500And1000: return "$500 – $1000"
        case .MoreThan1000: return "More than $1000"
        }
    }
}


enum Effort: String, Codable, CaseIterable {
    case Solo
    case With1
    case With2to4
    case CrossTeam
    case ExternalHelp

    var description: String {
        switch self {
        case .Solo: return "Solo"
        case .With1: return "With 1 other"
        case .With2to4: return "2–4 people"
        case .CrossTeam: return "Cross-team +4"
        case .ExternalHelp: return "External help"
        }
    }
}


struct Insight: Codable {
    var id: UUID = UUID()
    var title: String
    var notes: String
    var category: InsightCategory
    var priority: Category
    var audience: TargetAudience
//    var impact: Category
    var executionEffort: Effort
    var bugdet: Budget
}

struct Insights: Codable {
    var insights: [Insight]
}

struct PropertyItem {
    let title: String
    let iconName: String
    let options: [String]
}
