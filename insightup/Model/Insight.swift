//
//  Insight.swift
//  insightup
//
//  Created by Agatha Schneider on 13/05/25.
//

import Foundation
import UIKit

public enum InsightCategory: String, Codable, CaseIterable {
    case Ideas, Problems, Feelings, Observations, All
    
    public var imageName: String {
        [
            .Ideas: "lightbulb.fill",
            .Problems: "exclamationmark.bubble.fill",
            .Feelings: "heart.fill",
            .Observations: "eye.fill",
        ][self, default: "tray.fill"]
    }
    
    public var color: UIColor {
        [
            .Ideas: UIColor(named: "ColorsYellow")!,
            .Feelings: UIColor(named: "ColorsRed")!,
            .Problems: UIColor(named: "ColorsBlue")!,
            .Observations: UIColor(named: "ColorsGreen")!,
        ][self, default: .gray]
    }
}

public enum Category: String, Codable, CaseIterable {
    case High, Medium, Low, None
}

public enum TargetAudience: String, Codable, CaseIterable {
    case B2B, B2C, B2B2C, B2E, B2G, C2C, D2D
}

public enum Budget: String, Codable, CaseIterable {
    case LessThan100, Between100And500, Between500And1000, MoreThan1000
}

public enum Effort: String, Codable, CaseIterable {
    case Solo, With1, With2to4, CrossTeam, ExternalHelp
}



public struct Insight: Codable {
    public var id: UUID = UUID()
    public var title: String
    public var notes: String
    public var category: InsightCategory
    public var priority: Category
    public var audience: TargetAudience
//    var impact: Category
    public var executionEffort: Effort
    public var budget: Budget
    
    public init(title: String, notes: String, category: InsightCategory, priority: Category, audience: TargetAudience, executionEffort: Effort, budget: Budget) {
        self.title = title
        self.notes = notes
        self.category = category
        self.priority = priority
        self.audience = audience
        self.executionEffort = executionEffort
        self.budget = budget
    }
}

public struct Insights: Codable {
    public var insights: [Insight]
    
    public init(insights: [Insight]) {
        self.insights = insights
    }
}

public struct PropertyItem {
    public let title: String
    public let iconName: String
    public let options: [String]
    
    public init(title: String, iconName: String, options: [String]) {
        self.title = title
        self.iconName = iconName
        self.options = options
    }
}
