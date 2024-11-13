//
//  OrganizationView.swift
//  Test
//
//  Created by Solena Ornelas Pagnucci on 11/11/24.
//

import SwiftUI
import PhotosUI

// Organization Profile View
struct OrganizationView: View {
    // Sample Organization data
    @State private var organization = OrganizationProfile(name: "WE Bracelets", email: "organization@example.com", website: "organization.com", description: "A leading tech company", logo: nil, achievements: [Achievement(name: "First Product Launch"), Achievement(name: "Awarded Best Startup")])
    
    // For handling image picker
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage? = nil
    
    // Navigate to Edit Organization Profile Screen
    @State private var isEditingProfile = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Organization Header Section
                HStack {
                    // Organization Logo (Placeholder or Selected Image)
                    Group {
                        if let logo = organization.logo {
                            Image(uiImage: logo)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        } else {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Text(organization.name.prefix(1)) // First letter of organization name as placeholder
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                )
                        }
                    }
                    .onTapGesture {
                        // Show the image picker when tapping the logo
                        isImagePickerPresented.toggle()
                    }
                    
                    // Organization Information
                    VStack(alignment: .leading) {
                        Text(organization.name)
                            .font(.title)
                            .fontWeight(.bold)
                        Text(organization.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(organization.website)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(organization.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(2) // Limit description to two lines
                    }
                    
                    Spacer()
                }
                .padding()
                
                Divider()
                
                // Edit Profile and Switch Account Buttons
                HStack {
                    Button(action: {
                        isEditingProfile.toggle()
                    }) {
                        Text("Edit Profile")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $isEditingProfile) {
                        EditOrganizationProfileView(organization: $organization)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle switch account action (e.g., for admin to switch organizations)
                        print("Switch Account tapped")
                    }) {
                        Text("Switch Account")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                
                Divider()
                
                // Achievements Section
                VStack(alignment: .leading) {
                    Text("Achievements")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(organization.achievements) { achievement in
                                AchievementView(achievement: achievement)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                Spacer()
            }
            .padding()
            .imagePicker(isPresented: $isImagePickerPresented, selectedImage: $selectedImage, onImageSelected: { image in
                // Update organization logo after selection
                organization.logo = image
            })
        }
    }
}

// Achievement View to display individual achievements
struct AchievementView: View {
    var achievement: Achievement
    
    var body: some View {
        VStack {
            Image(systemName: "star.fill") // Achievement Icon (can be customized)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.yellow)
            
            Text(achievement.name)
                .font(.caption)
                .padding(.top, 5)
        }
        .frame(width: 80, height: 100)
        .padding(10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

// Organization Profile Data Model
struct OrganizationProfile {
    var name: String
    var email: String
    var website: String
    var description: String
    var logo: UIImage?
    var achievements: [Achievement]
}

// Achievement Data Model
struct Achievement: Identifiable {
    var id = UUID()
    var name: String
}

// Edit Organization Profile View
struct EditOrganizationProfileView: View {
    @Binding var organization: OrganizationProfile
    
    @State private var newName = ""
    @State private var newEmail = ""
    @State private var newWebsite = ""
    @State private var newDescription = ""
    
    // Dismiss action from environment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Your Organization Profile")) {
                    TextField("Organization Name", text: $newName)
                    TextField("Description", text: $newDescription)
                    TextField("Email", text: $newEmail)
                    TextField("Website", text: $newWebsite)
                }
                
                Button("Save Changes") {
                    // Save changes to organization
                    if !newName.isEmpty {
                        organization.name = newName
                    }
                    if !newEmail.isEmpty {
                        organization.email = newEmail
                    }
                    if !newWebsite.isEmpty {
                        organization.website = newWebsite
                    }
                    if !newDescription.isEmpty {
                        organization.description = newDescription
                    }
                    
                    // Close the sheet after saving
                    dismiss()
                }
                .padding()
            }
            .navigationTitle("Edit Organization Profile")
            .navigationBarItems(trailing: Button("Cancel") {
                // Dismiss the sheet
                dismiss()
            })
        }
    }
}



struct OrganizationView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationView()
    }
}
