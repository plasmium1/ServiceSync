//
//  TabView.swift
//  Test
//
//  Created by Solena Ornelas Pagnucci on 11/11/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
enum Tab{
    case calendar, home, person, search
}
    @EnvironmentObject private var authManager: AuthenticationManager
    @State private var selectedTab: Tab = .home
    var contextUser: String
    @StateObject var myEvents = EventStore()
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        if (contextUser == "manager") {
            ManagerPostView(contextUser: authManager.currentUser!)
        } else {
            TabView(selection: $selectedTab){
//                if let studentUser = viewModel.studentUser {
                    EventsCalendarView()
                        .environmentObject(myEvents)
                        .tabItem {
                            Label("Calendar", systemImage: "calendar")
                        }
                        .tag(Tab.calendar) // calendar tab
                    
                    SearchView()
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                        .tag(Tab.search) // search tab
                        .environmentObject(authManager)
                    
                    HomeScreen()
                        .tabItem{
                            Label("Home", systemImage: "house")
                        }
                        .tag(Tab.home) // home tab
                        .environmentObject(authManager)
                    
                    VolunteerView(isLoggedIn: $isLoggedIn)
                        .tabItem{
                            Label("Profile", systemImage: "person")
                        }
                        .tag(Tab.person) // profile tab
                        .environmentObject(authManager)
//                }
            }
            .task {
                await authManager.fetchUser()
            }
        }
    }
}

//#Preview {
//    ContentView(contextUser: placeholderStudent)
//        .environmentObject(EventStore())
//}
