//
//  ResultsView.swift
//  ClaimScan
//

import SwiftUI

struct ResultsView: View {
    var analysis: ClaimAnalysis
    var claim: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                Text("AI Claim Analysis")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                
                // CLAIM
                VStack(alignment: .leading, spacing: 8) {
                    Text("Claim Entered:")
                        .font(.headline)
                    Text("“\(claim)”")
                        .italic()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                // SCORE
                VStack(spacing: 10) {
                    Text("Truthfulness Score:")
                        .font(.headline)
                    
                    Text("\(analysis.score)")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(analysis.scoreColor)
                    
                    ProgressView(value: Double(analysis.score) / 100.0)
                        .tint(analysis.scoreColor)
                        .padding(.horizontal)
                }
                
                // SUMMARY
                VStack(alignment: .leading, spacing: 10) {
                    Text("Summary:")
                        .font(.headline)
                    Text(analysis.summary)
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                // SOURCES
                VStack(alignment: .leading, spacing: 10) {
                    Text("Sources:")
                        .font(.headline)
                    
                    if analysis.sources.isEmpty {
                        Text("No sources provided.")
                    } else {
                        ForEach(analysis.sources, id: \.self) { link in
                            Link(link, destination: URL(string: link)!)
                                .foregroundColor(.blue)
                                .underline()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - Score Color Helper
extension ClaimAnalysis {
    var scoreColor: Color {
        switch score {
        case 0..<40: return .red
        case 40..<70: return .orange
        default: return .green
        }
    }
}

#Preview {
    ResultsView(
        analysis: ClaimAnalysis(score: 78, summary: "Example summary", sources: ["https://example.com"]),
        claim: "Dogs can fly"
    )
}


