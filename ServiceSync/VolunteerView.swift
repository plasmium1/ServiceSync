//
//  VolunteerView.swift
//  ServiceSync
//
//  Created by AW on 11/13/24.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct VolunteerView: View {
    // For handling image picker
    @EnvironmentObject private var authManager: AuthenticationManager
    
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage? = nil
    
    // Navigate to Edit Profile Screen (example)
    @State private var isEditingProfile = false
    @State private var isNotLoggedIn = false
    @State private var attendedEvents: [Post] = []
    
    var body: some View {
        ScrollView {
            NavigationView {
                VStack {
                    if (authManager.currentUser != nil) {
                        // Profile Header Section
                        HStack {
                            // Profile Picture (Placeholder or Selected Image)
                            Group {
                                if let profileImage = authManager.currentUser!.getProfileImage() {
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
                                            Text(authManager.currentUser!.username.prefix(1)) // First letter of username as placeholder
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
                                Text(authManager.currentUser!.username)
                                    .font(.title)
                                    .fontWeight(.bold)
                                
                                Text(authManager.currentUser!.email)
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
                                EditVolunteerProfileView(user: authManager.currentUser!)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                // Handle switch account action
                                Task {
                                    print("Switch Account tapped")
                                    isNotLoggedIn = true
                                    print("toggledlogin")
                                    print("Signed out")
                                    authManager.signOut()
                                }
                            }) {
                                Text("Switch Account")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                            .navigationDestination(isPresented: $isNotLoggedIn) {
                                LoginView()
                            }
                        }
                        .padding()
                        
                        Divider()
                        
                        //                    // Badges Section
                        //                    VStack(alignment: .leading) {
                        //                        Text("Badges")
                        //                            .font(.title2)
                        //                            .fontWeight(.bold)
                        //                            .padding(.top)
                        //
                        //                        ScrollView(.horizontal, showsIndicators: false) {
                        //                            HStack {
                        //                                ForEach(authManager.currentUser!.getBadges(), id: \.self) { badgeID in
                        //                                    if let loadedAchievement = badgeLookUp(id: badgeID!) {
                        //                                        AchievementView(achievement: loadedAchievement)
                        //                                    }
                        //                                }
                        //                            }
                        //                        }
                        //                        .padding(.vertical)
                        //                    }
                        
                        //MARK: Events signed up stack
                        VStack {
                            ForEach(attendedEvents) { event in
                                Text("\(event.getTitle()) | \(event.getEventDate())")
                            }
                        }
                        
                        Spacer()
                        
                        Button() {
                            Task {
                                do {
                                    try await Auth.auth().currentUser?.delete()
                                } catch {
                                    print("Error occurred while attempting delete account \(error.localizedDescription)")
                                }
                            }
                        }label:{
                            Text("Delete account")
                                .font(.headline)
                                .foregroundStyle(.red)
                        }
                    }
                }
                .padding()
                .imagePicker(isPresented: $isImagePickerPresented, selectedImage: $selectedImage, onImageSelected: { selectedImage in
                    // Update profile image after selection
                    if let img = selectedImage {
                        authManager.currentUser!.setProfileImage(image: img)
                    } else {
                        authManager.currentUser!.setProfileImage(image: nil)
                    }
                })
            }
            .task {
                await authManager.fetchUser()
                if (attendedEvents.isEmpty) {
                    await fetchSignedUp()
                }
            }
        }
    }
    
    private func fetchSignedUp() async {
        
        let fs = Firestore.firestore()
        let au = Auth.auth()
        let uid = au.currentUser?.uid
        
        do {
            let userPostsData = try await fs.collection("users").document(uid!).getDocument().data()
            let postRefs: [DocumentReference] = userPostsData?["attendingEvents"] as! [DocumentReference]? ?? []
            
            for post in postRefs {
                let postData = try await post.getDocument().data(as: Post.self)
                attendedEvents.append(postData)
            }
        } catch {
            print("Failed to retrieve attended events \(error.localizedDescription)")
        }
        
    }
}

//struct VolunteerView_Previews: PreviewProvider {
//    static var previews: some View {
//        VolunteerView(authManager.currentUser!: placeholderStudent)
//    }
//}
