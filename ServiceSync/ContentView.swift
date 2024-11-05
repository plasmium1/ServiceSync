//  ContentView.swift
//  ProfileView
//
//  Created by Solena Ornelas Pagnucci on 10/28/24.
//

import SwiftUI

struct UserProfile {
    var name: String
    var age: String
    var email: String
    var profileImage: String // URL or image name
}

struct Badge: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    var earned: Bool = false // Track if the badge is earned
}

struct ContentView: View {
    @State private var user = UserProfile(name: "Solena OP", age: "16", email: "solenaop@gmail.com", profileImage: "dog")
    @State private var editProfileView = false
    @State private var badges: [Badge] = [
        Badge(name: "Star Badge", image: "star.fill"),
        Badge(name: "Tree Badge", image: "tree.fill"),
        Badge(name: "Pencil Badge", image: "pencil")
    ]
    
    @State private var isNavigating = false  // Track navigation state
    
    var body: some View {
        NavigationView {
            VStack {
                // Profile Picture
                Image(user.profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding()

                // User Information
                Text(user.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)

                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)

                Text("Age: " + user.age)
                    .font(.headline)

                Button(action: { editProfileView = true }) {
                    Text("Edit Profile")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                .sheet(isPresented: $editProfileView) {
                    EditProfileView(user: $user) // Pass the binding here
                }

                // Only display earned badges
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                    VStack {
                        Text("Badges")
                            .font(.title)
                            .foregroundColor(Color.white)
                            .padding()
                        HStack{
                            ForEach(badges.filter { $0.earned }) { badge in
                                VStack {
                                    Image(systemName: badge.image)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.yellow) // Show yellow since it's earned
                                    Text(badge.name)
                                        .font(.headline)
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                    }
                }

                Spacer()

                Button("Grant Star Badge") {
                    grantBadge(named: "Star Badge")
                }
                .padding()

                Button("Grant Tree Badge") {
                    grantBadge(named: "Tree Badge")
                }
                .padding()

                Button("Grant Pencil Badge") {
                    grantBadge(named: "Pencil Badge")
                }
                .padding()

                Spacer()

                // Switch Account Section
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Spacer()
                    Button(action: {
                        // Set to true when button is tapped, which will activate NavigationLink
                        isNavigating = true
                    }) {
                        Text("Switch Account")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.top)

                // NavigationLink wrapped around the Switch Account button logic
                NavigationLink(destination: ManagerProfileView(), isActive: $isNavigating) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
    
    private func grantBadge(named badgeName: String) {
        if let index = badges.firstIndex(where: { $0.name == badgeName }) {
            badges[index].earned = true // Mark badge as earned
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
