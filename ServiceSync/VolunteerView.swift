//
//  VolunteerView.swift
//  ServiceSync
//
//  Created by AW on 11/13/24.
//

import SwiftUI

struct VolunteerView: View {
    // Sample User data
    @StateObject var user: StudentUser
    
    // For handling image picker
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage? = nil
    
    // Navigate to Edit Profile Screen (example)
    @State private var isEditingProfile = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Profile Header Section
                HStack {
                    // Profile Picture (Placeholder or Selected Image)
                    Group {
                        if let profileImage = user.getProfileImage() {
                            Image(uiImage: profileImage)
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
                                    Text(user.username.prefix(1)) // First letter of username as placeholder
                                        .font(.largeTitle)
                                        .foregroundStyle(Color.white)
                                )
                        }
                    }
                    .onTapGesture {
                        // Show the image picker when tapping the profile picture
                        isImagePickerPresented.toggle()
                    }
                    
                    // User Information
                    VStack(alignment: .leading) {
                        Text(user.username)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)
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
                        EditVolunteerProfileView(user: user)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Handle switch account action
                        print("Switch Account tapped")
                    }) {
                        Text("Switch Account")
                            .font(.headline)
                            .foregroundColor(.red)
                    }
                }
                .padding()
                
                Divider()
                
                // Badges Section
                VStack(alignment: .leading) {
                    Text("Badges")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(user.getBadges(), id: \.self) { badgeID in
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
            .imagePicker(isPresented: $isImagePickerPresented, selectedImage: $selectedImage, onImageSelected: { selectedImage in
                // Update profile image after selection
                if let img = selectedImage {
                    user.setProfileImage(image: img)
                } else {
                    user.setProfileImage(image: nil)
                }
            })
        }
        
    }
}

//struct VolunteerView_Previews: PreviewProvider {
//    static var previews: some View {
//        VolunteerView(user: placeholderStudent)
//    }
//}
