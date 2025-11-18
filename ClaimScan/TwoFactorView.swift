//
//  TwoFactorView.swift
//  ClaimScan
//
//  Created by Cameron Tofani on 11/14/25.
//

import SwiftUI

struct TwoFactorView: View {
    @State private var code = ""
    
    var body: some View {
        ZStack {
            // Light orange background that adapts to light/dark mode
            Color(.systemOrange)
                .opacity(0.08)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Text("Two-Factor Verification")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)
                
                Text("Enter the 6-digit code sent to your device.")
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                TextField("123456", text: $code)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .frame(width: 150)
                
                NavigationLink("Verify") {
                    EnterClaimView()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 10)
                
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        TwoFactorView()
    }
}
