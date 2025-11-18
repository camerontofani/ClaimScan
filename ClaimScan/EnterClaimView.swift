//
//  EnterClaimView.swift
//  ClaimScan
//

import SwiftUI

struct EnterClaimView: View {
    @State private var claimText = ""
    @State private var analysis: ClaimAnalysis? = nil
    @State private var navigate = false
    @State private var isLoading = false
    
    //put open ai key herer
    let apiKey = "the key would be here"
    
    var body: some View {
        VStack(spacing: 25) {
            
            Text("Enter Your Claim")
                .font(.title)
                .bold()
                .padding(.top, 20)
            
            TextEditor(text: $claimText)
                .frame(height: 200)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            Button("Analyze Claim") {
                analyzeClaim()
            }
            .buttonStyle(.borderedProminent)
            .disabled(claimText.isEmpty || isLoading)
            
            if isLoading {
                ProgressView("Analyzing…")
                    .padding()
            }
            
            Image("shrimp")
                .resizable()
                .scaledToFit()
                .frame(width: 120)
                .opacity(0.9)
                .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .navigationDestination(isPresented: $navigate) {
            ResultsView(
                analysis: analysis ?? ClaimAnalysis(score: 0, summary: "No result", sources: []),
                claim: claimText
            )
        }
    }
    
    
    // MARK: - Analyze Claim
    func analyzeClaim() {
        isLoading = true
        
        Task {
            let result = await fetchAIAnalysis(text: claimText)
            self.analysis = result
            isLoading = false
            navigate = true
        }
    }
    
    
    // MARK: - Call OpenAI API
    func fetchAIAnalysis(text: String) async -> ClaimAnalysis {
        
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        let systemPrompt = """
You are a claim evaluation assistant. Analyze the user's claim as objectively and bias-free as possible.
Your job is to:
1. Determine how likely the claim is to be true using diverse, reputable sources.
2. Give a confidence score between 0 and 100.
3. Provide 3–5 reputable sources (links only).
4. Give a short explanation.

Output EXACTLY in this JSON structure:
{
  "score": number,
  "summary": "string",
  "sources": ["link1", "link2", "link3"]
}
NO MARKDOWN. NO EXTRA TEXT. ONLY JSON.
"""
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": systemPrompt],
                ["role": "user", "content": text]
            ]
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            // PRINT RAW HTTP RESPONSE
            if let httpResponse = response as? HTTPURLResponse {
                print("STATUS CODE:", httpResponse.statusCode)
            }
            print("RAW DATA STRING:")
            print(String(data: data, encoding: .utf8) ?? "NO DATA")

            // Continue decoding attempt
            let decoded = try JSONDecoder().decode(OpenAIResponse.self, from: data)
            var content = decoded.choices.first?.message.content ?? ""
            
            print("RAW GPT OUTPUT:\n\(content)\n")
            
            content = content
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let jsonStart = content.firstIndex(of: "{"),
               let jsonEnd = content.lastIndex(of: "}") {
                let jsonString = String(content[jsonStart...jsonEnd])
                
                if let jsonData = jsonString.data(using: .utf8) {
                    let parsed = try JSONDecoder().decode(ClaimAnalysis.self, from: jsonData)
                    return parsed
                }
            }

            return ClaimAnalysis(score: 0, summary: "Couldn't parse AI output.", sources: [])

        } catch {
            print("FATAL ERROR:", error.localizedDescription)
            return ClaimAnalysis(score: 0, summary: "Error: \(error.localizedDescription)", sources: [])
        }

    }
}


// MARK: - Models (GLOBAL — OUTSIDE VIEW)
struct ClaimAnalysis: Codable {
    let score: Int
    let summary: String
    let sources: [String]
}

struct OpenAIResponse: Codable {
    let choices: [OpenAIChoice]
}

struct OpenAIChoice: Codable {
    let message: OpenAIMessage
}

struct OpenAIMessage: Codable {
    let content: String
}

