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
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
