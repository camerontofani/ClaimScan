//
//  LoginView.swift
//  ClaimScan
//
//  Created by Cameron Tofani on 11/14/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            // Light orange background that adapts to light/dark mode
            Color(.systemOrange)
                .opacity(0.08)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Text("Log In")
                    .font(.largeTitle)
                    .bold()
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                NavigationLink("Continue") {
                    TwoFactorView()
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
        LoginView()
    }
}
