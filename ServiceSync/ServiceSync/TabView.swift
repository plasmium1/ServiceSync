//
//  TabView.swift
//  Test
//
//  Created by Solena Ornelas Pagnucci on 11/11/24.
//

import SwiftUI

struct ContentView: View {
enum Tab{
    case calendar, home, person, search
}
    @EnvironmentObject private var authManager: AuthenticationManager
    @State private var selectedTab: Tab = .home
    var contextUser: String
    @StateObject var myEvents = EventStore()
    @StateObject private var viewModel = StudentUserViewModel()
    
    var body: some View {
        if (contextUser == "student") {
            TabView(selection: $selectedTab){
                if let studentUser = viewModel.studentUser {
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
                    
                    VolunteerView(user: studentUser)
                        .tabItem{
                            Label("Profile", systemImage: "person")
                        }
                        .tag(Tab.person) // profile tab
                }
            }
            .onAppear {
                viewModel.viewLoadStudentUser(userID: authManager.user!.id)
            }
        } else if (contextUser == "manager") {
            ManagerPostView(contextUser: contextUser as! ManagerUser)
        }
    }
}

class StudentUserViewModel: ObservableObject {
    @Published var studentUser: StudentUser?
    @Published var errorMessage: String?

    func viewLoadStudentUser(userID: String) {
        loadStudentUser(userID: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.studentUser = user
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ContentView(contextUser: placeholderStudent)
        .environmentObject(EventStore())
}
