//
//  ManagerPostView.swift
//  ServiceSync
//
//  Created by AW on 11/6/24.
//

import SwiftUI

import Firebase
import FirebaseFirestore



struct ManagerPostView: View {
    @State private var showForm = false
    @State var contextUser: User
    @State private var posts: [Post] = [] // State variable for posts

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(posts) { post in
                        PostView(post: post, contextUser: contextUser)
                    }
                    
                    // Add Post Button
                    Button(action: {
                        withAnimation {
                            showForm.toggle()
                        }
                    }) {
                        Image(systemName: showForm ? "minus" : "plus")
                            .font(.largeTitle)
                            .padding()
                            .frame(width: 70, height: 70)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding()
                    
                    if showForm {
                        AddPostForm(contextUser: contextUser)
                            .transition(.slide)
                    }
                }
            }
            .navigationTitle("Posts")
            .onAppear {
                setupPostListener() // setup the post listener
            }
        }
    }
//
//    func fetchPosts() {
//        let db = Firestore.firestore()
//        db.collection("posts").getDocuments { snapshot, error in
//            if let error = error {
//                print("Error fetching posts: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let documents = snapshot?.documents else {
//                print("No posts found")
//                return
//            }
//            
//            let fetchedPosts = documents.compactMap { document -> Post? in
//                let data = document.data()
//                
//                guard
//                    let postManagerID = data["postManagerID"] as? String,
//                    let title = data["title"] as? String,
//                    let postContent = data["postContent"] as? String,
//                    let location = data["location"] as? String,
//                    let eventDate = data["eventDate"] as? String,
//                    let tagsArray = data["tags"] as? [[String: Any]]
//                else {
//                    print("Error parsing post data for document ID: \(document.documentID)")
//                    return nil
//                }
//                
//                // Convert optional properties
//                let likes = data["likes"] as? Int
//                let commentsArray = data["comments"] as? [[String: Any]]
//                let reportsArray = data["reports"] as? [String]
//                
//                // Load tags
//                let tags = tagsArray.compactMap { Tag.fromDictionary($0) }
//                
//                // Load comments if any
//                let comments = commentsArray?.compactMap { Comment.fromDictionary($0) }
//                
//                // Load post image (optional)
//                var postImage = UIImage()
//                if let imageURLString = data["postImageURL"] as? String,
//                   let imageURL = URL(string: imageURLString),
//                   let imageData = try? Data(contentsOf: imageURL) {
//                    postImage = UIImage(data: imageData) ?? UIImage()
//                }
//                
//                // Initialize the Post object
//                return Post(
//                    postManager: postManagerID,
//                    title: title,
//                    postImage: postImage,
//                    postContent: postContent,
//                    location: location,
//                    eventDate: eventDate,
//                    likes: likes ?? 0,
//                    comments: comments ?? [],
//                    tags: tags
//                )
//            }
//            
//            DispatchQueue.main.async {
//                self.posts = fetchedPosts
//            }
//        }
//    }


    func setupPostListener() {
        let db = Firestore.firestore()
        db.collection("posts").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error listening for posts: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No posts found")
                return
            }
            
            do {
                let updatedPosts = try documents.compactMap { document -> Post? in
                    let post = try document.data(as: Post.self)
                    return post
                }
                DispatchQueue.main.async {
                    self.posts = updatedPosts
                }
            } catch {
                print("Error decoding posts: \(error.localizedDescription)")
            }
        }
    }

}

//#Preview {
//    ManagerPostView(contextUser: placeholderManager)
//}
