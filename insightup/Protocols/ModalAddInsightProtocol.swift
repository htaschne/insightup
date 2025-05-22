//
//  ModalAddInsightProtocol.swift
//  insightup
//
//  Created by Agatha Schneider on 19/05/25.
//

protocol ModalAddInsightDelegate: AnyObject {
    func didAddInsight(_ insight: Insight)
    func didUpdateInsight(_ insight: Insight)
}
