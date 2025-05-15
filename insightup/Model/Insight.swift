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

enum Category: String, Codable {
    case High, Medium, Low, None
}

enum TargetAudience: String, Codable {
    case B2B, B2C, B2B2C, B2E, B2G, C2C, D2D
}

enum Budget: String, Codable {
    case LessThan100, Between100And500, Between500And1000, MoreThan1000
}

enum Effort: String, Codable {
    case Solo, With1, With2to4, CrossTeam, ExternalHelp
}

struct Insight: Codable {
    var id: UUID = UUID()
    var title: String
    var notes: String
    var category: InsightCategory
    var priority: Category
    var audience: TargetAudience
    var impact: Category
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
