//
//  MainAppView.swift
//  ServiceSync
//
//  Created by AW on 12/9/24.
//

import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var isLoggedIn: Bool = false

    var body: some View {
        Group {
            if let user = authManager.currentUser {
                if user.role == "student" {
                    ContentView(contextUser: "student", isLoggedIn: $isLoggedIn)
                        .onAppear {
                            isLoggedIn = true
                        }
                } else if user.role == "manager" {
                    ContentView(contextUser: "manager", isLoggedIn: $isLoggedIn)
                        .onAppear {
                            isLoggedIn = true
                        }
                }
            } else {
                LoginView()
            }
        }
    }
}



#Preview {
    MainAppView()
}
