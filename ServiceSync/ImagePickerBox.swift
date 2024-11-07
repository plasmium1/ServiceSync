//
//  ImagePickerBox.swift
//  ServiceSync
//
//  Created by AW on 11/4/24.
//

import SwiftUI
import PhotosUI

enum ImageUser {
    case managerUser(ManagerUser)
    case studentUser(StudentUser)
    
    init(_ user: ManagerUser) {
        self = .managerUser(user)
    }
    init(_ user: StudentUser) {
        self = .studentUser(user)
    }
    
    func getImage() -> Image {
        switch self {
        case .managerUser(let user):
            return user.getProfileImage()
        case .studentUser(let user):
            return user.getProfileImage()
        }
    }
}

struct ImagePickerBox: View {
    @State private var isPickerPresented = false
    @State private var selectedImage: UIImage?
    @State var profileUser: ImageUser
    var body: some View {
        VStack {
            Button(action: {
                isPickerPresented = true
            }) {
                // Display the selected image if available, otherwise show a placeholder
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                } else {
                    profileUser.getImage()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .foregroundColor(.gray)
                        .background(Color.secondary.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            .buttonStyle(PlainButtonStyle()) // Removes default button styling
        }
        .sheet(isPresented: $isPickerPresented) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // Limit to images only
        config.selectionLimit = 1 // Allow one image to be selected

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

            provider.loadObject(ofClass: UIImage.self) { image, error in
                if let uiImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.selectedImage = uiImage
                    }
                }
            }
        }
    }
}

#Preview {
    ImagePickerBox(profileUser: ImageUser(placeholderManager))
}
