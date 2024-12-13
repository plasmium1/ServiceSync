//
//  AddPostForm.swift
//  ServiceSync
//
//  Created by AW on 11/6/24.
//

import SwiftUI
import PhotosUI // Required for the image picker

import SwiftUI
import PhotosUI

struct AddPostForm: View {
    @Binding var posts: [Post]
    @State var contextUser: User
    @State private var username: String = "New User"
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var eventDate: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedTags: Set<Tag> = []
    @State private var availableTags: [Tag] = [
        Tag(name: "Tech", type: "Tech"),
        Tag(name: "Arts", type: "Arts"),
        Tag(name: "Sports", type: "Sports"),
        Tag(name: "Culinary", type: "Culinary"),
        Tag(name: "Civic Engagement", type: "Civic Engagement")
    ]

    var body: some View {
        ScrollView {
            VStack {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Description", text: $description)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                TextField("Location", text: $location)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                DatePicker("Event Date", selection: Binding(
                    get: {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        return dateFormatter.date(from: eventDate) ?? Date()
                    },
                    set: { date in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        eventDate = dateFormatter.string(from: date)
                    }
                ), displayedComponents: .date)
                .padding()

                // Image Picker
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding()
                }

                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Text("Select Image")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            selectedImage = uiImage
                        }
                    }
                }

                // Tag Selection
                VStack(alignment: .leading) {
                    Text("Select Tags")
                        .font(.headline)
                        .padding(.vertical, 5)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(availableTags, id: \.id) { tag in
                                TagView(tag: tag, isSelected: selectedTags.contains(tag)) {
                                    if selectedTags.contains(tag) {
                                        selectedTags.remove(tag)
                                    } else {
                                        selectedTags.insert(tag)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()

                // Add Post Button
                Button("Add Post") {
                    let newPost = Post(
                        postManager: contextUser.getID(),
                        title: title,
                        postImage: selectedImage,
                        postContent: description,
                        location: location,
                        eventDate: eventDate,
                        likes: 0,
                        comments: [],
                        tags: Array(selectedTags)
                    )
                    
                    uploadPost(post: newPost) { result in
                        switch result {
                        case .success:
                            print("Uploaded new post")
                            posts.append(newPost)
                            clearFields()
                        case .failure(let error):
                            print("Failed to upload post \(error.localizedDescription)")
                        }
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }

    private func clearFields() {
        title = ""
        description = ""
        location = ""
        eventDate = ""
        selectedImage = nil
        selectedTags.removeAll()
    }
}


// Tag View for rendering tags
struct TagView: View {
    let tag: Tag
    let isSelected: Bool
    let toggleSelection: () -> Void

    var body: some View {
        Text(tag.name)
            .padding(8)
            .background(isSelected ? tag.getTypeColor() : Color.gray.opacity(0.2))
            .foregroundColor(.white)
            .cornerRadius(8)
            .onTapGesture {
                toggleSelection()
            }
    }
}

//#Preview {
//    AddPostForm(posts: placeholderPostArray)
//}
