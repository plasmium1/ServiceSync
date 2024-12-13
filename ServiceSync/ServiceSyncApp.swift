//
//  ServiceSyncApp.swift
//  ServiceSync
//
//  Created by AW on 10/17/24.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct ServiceSyncApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var eventStore = EventStore()
    @StateObject private var authManager = AuthenticationManager()
//    init() {
//        FirebaseApp.configure()
//    }
    var body: some Scene {
        WindowGroup {
            MainAppView()
                .environmentObject(authManager)
        }
    }
}
