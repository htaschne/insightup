//
//  InsightPersistence.swift
//  insightup
//
//  Created by Agatha Schneider on 13/05/25.
//

import Foundation

public struct InsightPersistence {
    private static let key = "insightup"

    public static func getAll() -> Insights {
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            do {
                let insights = try JSONDecoder().decode(Insights.self, from: data)
                return insights
            } catch {
                print(error.localizedDescription)
            }
        }

        let newInsights = Insights(insights: [])
        save(insights: newInsights)
        return newInsights
    }

    public static func save(insights: Insights) {
        do {
            let data = try JSONEncoder().encode(insights)
            UserDefaults.standard.setValue(data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }

    public static func saveInsight(newInsight: Insight) {
        var insights = getAll()
        insights.insights.append(newInsight)
        do {
            let data = try JSONEncoder().encode(insights)
            UserDefaults.standard.setValue(data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }

    public static func deleteInsight(at index: Int) {
        var insights = getAll()
        insights.insights.remove(at: index)
        do {
            let data = try JSONEncoder().encode(insights)
            UserDefaults.standard.setValue(data, forKey: key)
        } catch {
            print(error.localizedDescription)
        }
    }

    public static func getAllBy(category: InsightCategory) -> [Insight] {
        return category == .All ? getAll().insights : getAll().insights.filter { $0.category == category }
    }
}
