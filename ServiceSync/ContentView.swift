//
//  ContentView.swift
//  Test
//
//  Created by Solena Ornelas Pagnucci on 11/11/24.
//

import SwiftUI
import PhotosUI

struct VolunteerView: View {
    // Sample User data
    @State private var user = User(username: "JohnDoe", email: "johndoe@example.com", profileImage: nil, badges: [Badge(name: "First Login"), Badge(name: "Completed Challenge"), Badge(name: "Volunteer 5 times"), Badge(name: "Volunteer 10 times"), Badge(name: "Stand Out"),])
    
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
                        if let profileImage = user.profileImage {
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
                                        .foregroundColor(.white)
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
                        EditProfileView(user: $user)
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
                            ForEach(user.badges) { badge in
                                BadgeView(badge: badge)
                            }
                            
                        }
                    }
                    .padding(.vertical)
                }
                
                Spacer()
            }
            .padding()
            .imagePicker(isPresented: $isImagePickerPresented, selectedImage: $selectedImage, onImageSelected: { image in
                // Update profile image after selection
                user.profileImage = image
            })
        }
    }
}

struct BadgeView: View {
    var badge: Badge
    
    var body: some View {
        VStack {
            Image(systemName: "star.fill") // Badge Icon (could be dynamic based on the badge)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.yellow)
            
            Text(badge.name)
                .font(.caption)
                .padding(.top, 5)
        }
        .frame(width: 80, height: 100)
        .padding(10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

// Sample Data Models
struct User {
    var username: String
    var email: String
    var profileImage: UIImage?
    var badges: [Badge]
}

struct Badge: Identifiable {
    var id = UUID()
    var name: String
}

// Edit Profile View (Example)
struct EditProfileView: View {
    @Binding var user: User
    
    @State private var newUsername = ""
    @State private var newEmail = ""
    
    // Dismiss action from environment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Your Profile")) {
                    TextField("Username", text: $newUsername)
                    TextField("Email", text: $newEmail)
                }
                
                Button("Save Changes") {
                    // Save changes to user (for demo purposes we just update the UI)
                    if !newUsername.isEmpty {
                        user.username = newUsername
                    }
                    if !newEmail.isEmpty {
                        user.email = newEmail
                    }
                    
                    // Close the sheet after saving
                    dismiss()
                }
                .padding()
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(trailing: Button("Cancel") {
                // Dismiss the sheet
                dismiss()
            })
        }
    }
}

// Custom modifier for presenting the image picker
struct ImagePicker: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    var onImageSelected: (UIImage) -> Void
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                ImagePickerController(isPresented: $isPresented, selectedImage: $selectedImage, onImageSelected: onImageSelected)
            }
    }
}

// ImagePickerController as a UIViewControllerRepresentable to use UIImagePickerController
struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedImage: UIImage?
    var onImageSelected: (UIImage) -> Void
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerController
        
        init(parent: ImagePickerController) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.onImageSelected(image)
            }
            parent.isPresented = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// View extension to apply ImagePicker modifier
extension View {
    func imagePicker(isPresented: Binding<Bool>, selectedImage: Binding<UIImage?>, onImageSelected: @escaping (UIImage) -> Void) -> some View {
        self.modifier(ImagePicker(isPresented: isPresented, selectedImage: selectedImage, onImageSelected: onImageSelected))
    }
}

struct VolunteerView_Previews: PreviewProvider {
    static var previews: some View {
        VolunteerView()
    }
}
