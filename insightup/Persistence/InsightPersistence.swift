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
        guard let data = UserDefaults.standard.value(forKey: key) as? Data else {
            print("Nenhum dado encontrado no UserDefaults. Criando nova lista de insights vazia.")
            let newInsights = Insights(insights: [])
            save(insights: newInsights)
            return newInsights
        }
        
        do {
            let insights = try JSONDecoder().decode(Insights.self, from: data)
            print("Sucesso ao carregar \(insights.insights.count) insights")
            return insights
        } catch {
            print("Erro ao decodificar insights: \(error.localizedDescription)")
            // Se houver erro ao decodificar, retorna uma lista vazia
            let newInsights = Insights(insights: [])
            save(insights: newInsights)
            return newInsights
        }
    }

    public static func save(insights: Insights) {
        do {
            let data = try JSONEncoder().encode(insights)
            UserDefaults.standard.setValue(data, forKey: key)
            print("Dados salvos com sucesso no UserDefaults")
        } catch {
            print("Erro ao salvar insights: \(error.localizedDescription)")
            // Tentar salvar uma lista vazia em caso de erro
            if let emptyData = try? JSONEncoder().encode(Insights(insights: [])) {
                UserDefaults.standard.setValue(emptyData, forKey: key)
            }
        }
    }

    public static func saveInsight(newInsight: Insight) {
        var insights = getAll()
        
        // Verificar se já existe um insight com o mesmo ID
        if let index = insights.insights.firstIndex(where: { $0.id == newInsight.id }) {
            // Atualizar insight existente
            insights.insights[index] = newInsight
        } else {
            // Adicionar novo insight
            insights.insights.append(newInsight)
        }
        
        // Salvar as alterações
        do {
            let data = try JSONEncoder().encode(insights)
            UserDefaults.standard.setValue(data, forKey: key)
        } catch {
            print("Erro ao salvar insight: \(error.localizedDescription)")
        }
    }

    public static func deleteInsight(at index: Int) -> Bool {
        var insights = getAll()
        guard index >= 0 && index < insights.insights.count else {
            print("Índice \(index) inválido para exclusão")
            return false
        }
        
        let insightToDelete = insights.insights[index]
        insights.insights.remove(at: index)
        
        do {
            let data = try JSONEncoder().encode(insights)
            UserDefaults.standard.setValue(data, forKey: key)
            print("Insight '\\(insightToDelete.title)' removido com sucesso")
            return true
        } catch {
            print("Erro ao remover insight: \(error.localizedDescription)")
            return false
        }
    }

    public static func getAllBy(category: InsightCategory) -> [Insight] {
        return category == .All ? getAll().insights : getAll().insights.filter { $0.category == category }
    }

    @discardableResult
    public static func updateInsight(updatedInsight: Insight) -> Bool {
        var insights = getAll()
        guard let index = insights.insights.firstIndex(where: { $0.id == updatedInsight.id }) else {
            print("Insight com ID \(updatedInsight.id) não encontrado para atualização")
            return false
        }
        
        insights.insights[index] = updatedInsight
        save(insights: insights)
        print("Insight '\\(updatedInsight.title)' atualizado com sucesso")
        return true
    }
}
