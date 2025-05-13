//
//  Insight.swift
//  insightup
//
//  Created by Agatha Schneider on 13/05/25.
//

import Foundation

enum InsightCategory: String, Codable, CaseIterable {
    case Ideas, Problems, Feelings, Observations
}

enum Category: String, Codable {
    case High, Medium, Low, None
}

struct Insight: Codable {
    var id: UUID = UUID()
    var title: String
    var notes: String
    var category: InsightCategory
    var priority: Category
    var audience: [String]
    var impact: Category
    var bugdet: Category
}

struct Insights: Codable {
    var insights: [Insight]
}
