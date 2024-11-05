//
//  EditProfileView.swift
//  ProfileView
//
//  Created by Solena Ornelas Pagnucci on 10/28/24.
//

import SwiftUI

struct editManagerProfile {
    var organization: String
    var email: String
    var website: String
    var profileImage: String // This can be a URL or image name
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var image: UIImage?

        init(image: Binding<UIImage?>) {
            _image = image
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[.originalImage] as? UIImage {
                image = pickedImage
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(image: $image)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No updates needed
    }
}

struct editManagerProfileView: View {
    @Binding var user: ManagerProfile
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var editOrganization: String
    @State private var editWebsite: String
    @State private var editEmail: String

    init(user: Binding<ManagerProfile>) {
        self._user = user
        self._editOrganization = State(initialValue: user.wrappedValue.organization)
        self._editWebsite = State(initialValue: user.wrappedValue.website)
        self._editEmail = State(initialValue: user.wrappedValue.email)
        
    }

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 50, height: 5)
            Text("Edit Profile")
                .font(.title)
            Spacer()
            TextField("Name", text: $editOrganization)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()


            TextField("Email", text: $editEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                showImagePicker = true
            }) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 150, height: 150)
                        .overlay(Text("Add Photo").foregroundColor(.white))
                }
            }
            .sheet(isPresented: $showImagePicker) {
                PhotoPicker(image: $selectedImage) // Use PhotoPicker here
            }

            Button(action: {
                saveProfile()
            }) {
                Text("Save Changes")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(editOrganization.isEmpty || editEmail.isEmpty)
            Spacer()
            Spacer()
        }
        .padding()
    }

    private func saveProfile() {
        // Update the user profile with new values
        user.organization = editOrganization
        user.email = editEmail
        user.website = editWebsite // Don't forget to update website
        
        // Optionally handle image upload if necessary
        if let image = selectedImage {
            uploadImage(image)
        }
        
        print("Profile updated: \(user)")
    }

    private func uploadImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        // Specify your upload URL
        guard let url = URL(string: "YOUR_UPLOAD_URL") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set content type to image/jpeg
        request.setValue("multipart/form-data; boundary=\(UUID().uuidString)", forHTTPHeaderField: "Content-Type")

        // Build the body data
        var body = Data()
        
        // Append the image data
        body.append("--\(UUID().uuidString)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(UUID().uuidString)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // Perform the upload
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error: \(String(describing: response))")
                return
            }

            // Handle successful upload
            print("Image uploaded successfully!")
        }

        task.resume()
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var userProfile = ManagerProfile(organization: "", email: "", website: "", profileImage: "") // Correct struct name
        
        var body: some View {
            EditManagerProfileView(user: $userProfile)
        }
    }
    
    return PreviewWrapper()
}
