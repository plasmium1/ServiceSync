//
//  ServiceSyncApp.swift
//  ServiceSync
//
//  Created by AW on 10/17/24.
//

import SwiftUI
import Firebase

@main
struct ServiceSyncApp: App {
    @StateObject private var eventStore = EventStore()
    @StateObject private var authManager = AuthenticationManager()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainAppView()
                .environmentObject(authManager)
        }
    }
}
