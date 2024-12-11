//
//  ImagePicker.swift
//  ServiceSync
//
//  Created by AW on 11/13/24.
//

import SwiftUI

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
    func imagePicker(isPresented: Binding<Bool>, selectedImage: Binding<UIImage?>, onImageSelected: @escaping (UIImage?) -> Void) -> some View {
        self.modifier(ImagePicker(isPresented: isPresented, selectedImage: selectedImage, onImageSelected: onImageSelected))
    }
}

