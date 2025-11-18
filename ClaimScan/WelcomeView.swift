//
//  WelcomeView.swift
//  ClaimScan
//
//  Created by Cameron Tofani on 11/14/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 40) {
            
            Image("shrimp")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .padding(.top, 40)
            
            Text("ClaimScan")
                .font(.largeTitle)
                .bold()
            
            Text("Verify claims quickly with\nAI-powered analysis.")
                .multilineTextAlignment(.center)
                .padding()
            
            NavigationLink("Get Started") {
                LoginView()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}

