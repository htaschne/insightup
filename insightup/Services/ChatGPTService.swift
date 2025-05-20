import Foundation

enum ChatGPTError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case apiError(String)
}

/// Serviço para interagir com a API do ChatGPT/GPT-4
class ChatGPTService {
    private let apiKey: String
    private let session: URLSession
    private let model: String
    
    init(model: String = "gpt-4o-mini") {
        self.apiKey = APIKeys.openAIKey
        self.model = model
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 300
        config.waitsForConnectivity = true
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.session = URLSession(configuration: config)
    }
    
    /// Gera uma resposta usando a API do ChatGPT
    /// - Parameters:
    ///   - prompt: Texto do usuário
    ///   - instructions: Instruções para o agente
    ///   - previousResponseID: ID de resposta anterior para continuar conversa (opcional)
    func generateResponse(prompt: String, instructions: String, previousResponseID: String? = nil) async throws -> String {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw ChatGPTError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let messages: [[String: String]] = [
            ["role": "system", "content": instructions],
            ["role": "user", "content": prompt]
        ]
        
        let payload: [String: Any] = [
            "model": model,
            "messages": messages,
            "temperature": 0.3
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            throw ChatGPTError.networkError(error)
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
            }
            if let responseString = String(data: data, encoding: .utf8) {
                print("Resposta bruta da API:", responseString)
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let error = (errorJson["error"] as? [String: Any])?["message"] as? String {
                    throw ChatGPTError.apiError(error)
                }
                throw ChatGPTError.apiError(String(data: data, encoding: .utf8) ?? "Resposta inválida da API")
            }
            let decoded = try JSONDecoder().decode(ChatCompletionsResponse.self, from: data)
            return decoded.choices.first?.message.content ?? "No response"
        } catch let error as DecodingError {
            throw ChatGPTError.decodingError(error)
        } catch {
            throw ChatGPTError.networkError(error)
        }
    }
}

// MARK: - Modelos para API chat/completions

/// Estrutura da resposta do endpoint 'chat/completions'
struct ChatCompletionsResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [Choice]
    let usage: Usage
}

struct Choice: Codable {
    let index: Int
    let message: Message
    let finishReason: String
    
    enum CodingKeys: String, CodingKey {
        case index
        case message
        case finishReason = "finish_reason"
    }
}

struct Message: Codable {
    let role: String
    let content: String
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}
