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
    @EnvironmentObject private var authManager: AuthenticationManager
//    @StateObject var authManager.currentUser!: User
    
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
                        if let logo = authManager.currentUser!.getProfileImage() {
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
                                    Text(authManager.currentUser!.getUsername().prefix(1)) // First letter of authManager.currentUser! name as placeholder
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                )
                        }
                    }
                    .onTapGesture {
                        // Show the image picker when tapping the logo
                        isImagePickerPresented.toggle()
                    }
                    
                    // Organization Information
                    VStack(alignment: .leading) {
                        Text(authManager.currentUser!.getUsername())
                            .font(.title)
                            .fontWeight(.bold)
                        Text(authManager.currentUser!.getEmail())
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        if let website = authManager.currentUser!.getWebsite() {
                            Text(website)
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        } else {
                            Text("No website")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                        Text(authManager.currentUser!.getDescription())
                            .font(.subheadline)
                            .foregroundStyle(.gray)
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
                            .foregroundStyle(.blue)
                    }
                    .sheet(isPresented: $isEditingProfile) {
                        EditOrganizationProfileView(organization: authManager.currentUser!)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle switch account action (e.g., for admin to switch authManager.currentUser!s)
                        print("Switch Account tapped")
                    }) {
                        Text("Switch Account")
                            .font(.headline)
                            .foregroundStyle(.red)
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
                            ForEach(authManager.currentUser!.getBadges(), id: \.self) { badgeID in
                                if let loadedAchievement = badgeLookUp(id: badgeID!) {
                                    AchievementView(achievement: loadedAchievement)
                                }
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                Spacer()
            }
            .padding()
            .imagePicker(isPresented: $isImagePickerPresented, selectedImage: $selectedImage, onImageSelected: { image in
                // Update authManager.currentUser! logo after selection
                if let img = image {
                    authManager.currentUser!.setProfileImage(image: img)
//                    uploadManagerUserWithImage(authManager.currentUser!)
                } else {
                    authManager.currentUser!.setProfileImage(image: nil)
//                    uploadManagerUserWithImage(authManager.currentUser!)
                }
            })
        }
        .task {
            await authManager.fetchUser()
        }
    }
}
