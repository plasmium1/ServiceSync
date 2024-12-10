//
//  MainAppView.swift
//  ServiceSync
//
//  Created by AW on 12/9/24.
//

import SwiftUI

struct MainAppView: View {
    @EnvironmentObject var authManager: AuthenticationManager

    var body: some View {
        if authManager.isLoading {
            ProgressView("Loading...")
        } else if let user = authManager.user {
            if user.role == "student" {
                ContentView(contextUser: "student")
            } else if user.role == "manager" {
                ContentView(contextUser: "manager")
            }
        } else {
            LoginView()
        }
    }
}


#Preview {
    MainAppView()
}
