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
@State private var selectedTab: Tab = .home
    
var body: some View {
    TabView(selection: $selectedTab){
        
        CalendarView()
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            .tag(Tab.calendar) // calendar tab
        
        SearchView()
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }
            .tag(Tab.search) // search tab
        
        HomeView()
            .tabItem{
                Label("Home", systemImage: "house")
            }
            .tag(Tab.home) // home tab
        
        VolunteerView()
            .tabItem{
                Label("Alerts", systemImage: "person")
            }
            .tag(Tab.person) // profile tab
        
        
    }
}
}

#Preview {
    ContentView()
}
