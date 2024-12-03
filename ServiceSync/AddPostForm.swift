//
//  AddPostForm.swift
//  ServiceSync
//
//  Created by AW on 11/6/24.
//

import SwiftUI

struct AddPostForm: View {
    @Binding var posts: [Post]
    @State var contextUser: ManagerUser
    @State private var username: String = "New User" // Default username
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var eventDate: String = ""

    var body: some View {
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

            Button("Add Post") {
                let newPost = Post(postManager: contextUser, title: title, postImage: Image("samplePhoto1"), postContent: description, location: location, eventDate: eventDate, likes: 0, comments: [], tags: [])
                posts.append(newPost)
                // Clear fields after adding
                title = ""
                description = ""
                location = ""
                eventDate = ""
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .animation(.easeInOut, value: posts.count) // Add animation for posts
    }
}

//#Preview {
//    AddPostForm(posts: placeholderPostArray)
//}
