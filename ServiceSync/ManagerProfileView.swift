//  ContentView.swift
//  ProfileView
//
//  Created by Solena Ornelas Pagnucci on 10/28/24.
//

import SwiftUI

struct ManagerProfile {
    var organization: String
    var email: String
    var website: String
    var profileImage: String // URL or image name
}

struct Badges: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    var earned: Bool = false // Track if the badge is earned
}

struct ManagerProfileView: View {
    @State private var user = ManagerProfile(organization: "WE Bracelets", email: "webracelets@gmail.com", website: "webracelets.com", profileImage: "dog")
    @State private var editProfileView = false
    @State private var badges: [Badges] = [
        Badges(name: "Star Badge", image: "star.fill"),
        Badges(name: "Tree Badge", image: "tree.fill"),
        Badges(name: "Pencil Badge", image: "pencil")
    ]
    
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
                Text(user.email)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)

                Text(user.website)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 8)

                // Edit Profile Button
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
                    EditManagerProfileView(user: $user) // Use the correct capitalized name
                }

                // Badges Section
                VStack {
                    Text("Badges")
                        .font(.title)
                        .foregroundColor(Color.blue)
                        .padding()

                    HStack {
                        ForEach(badges.filter { $0.earned }) { badge in
                            VStack {
                                Image(systemName: badge.image)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.yellow) // Show yellow since it's earned
                                Text(badge.name)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }
                            .padding()
                        }
                    }
                }
                .padding(.top)

                Spacer()

                // Grant Badges Buttons
                VStack(spacing: 16) {
                    Button("Grant Star Badge") {
                        grantBadge(named: "Star Badge")
                    }
                    .buttonStyle(BlueButtonStyle())

                    Button("Grant Tree Badge") {
                        grantBadge(named: "Tree Badge")
                    }
                    .buttonStyle(BlueButtonStyle())

                    Button("Grant Pencil Badge") {
                        grantBadge(named: "Pencil Badge")
                    }
                    .buttonStyle(BlueButtonStyle())

                }
                .padding()

                // Switch Account Section
                HStack {
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                    Spacer()
                    Button(action: {
                        // Logout Action
                        print("Switching Account")
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

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

// The EditManagerProfileView that accepts a Binding to the ManagerProfile
struct EditManagerProfileView: View { // Capitalized name here
    @Binding var user: ManagerProfile
    @State private var editOrganization: String
    @State private var editEmail: String
    @State private var editWebsite: String
    @State private var editProfileImage: String

    init(user: Binding<ManagerProfile>) {
        self._user = user
        self._editOrganization = State(initialValue: user.wrappedValue.organization)
        self._editEmail = State(initialValue: user.wrappedValue.email)
        self._editWebsite = State(initialValue: user.wrappedValue.website)
        self._editProfileImage = State(initialValue: user.wrappedValue.profileImage)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile Info")) {
                    TextField("Organization", text: $editOrganization)
                    TextField("Email", text: $editEmail)
                    TextField("Website", text: $editWebsite)
                    TextField("Profile Image", text: $editProfileImage)
                }

                Button("Save Changes") {
                    saveProfile()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .navigationTitle("Edit Profile")
        }
    }

    private func saveProfile() {
        // Update the profile with new values
        user.organization = editOrganization
        user.email = editEmail
        user.website = editWebsite
        user.profileImage = editProfileImage
    }
}

struct ManagerProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerProfileView()
    }
}
