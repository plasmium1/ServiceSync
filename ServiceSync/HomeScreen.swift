//
//  HomeScreen.swift
//  ServiceSync
//
//  Created by ECC on 10/19/24.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct HomeScreen: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    @State private var postsList: [Post] = []
    @State private var isLoading = true
    @State private var isUserLoading = true

    var body: some View {
        VStack {
            TopBar()

            if isLoading {
                ProgressView("Loading Posts...")
            } else if postsList.isEmpty {
                Text("No posts available")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    ForEach(postsList) { post in
                        if let currentUser = authManager.currentUser {
                            PostView(post: post, contextUser: currentUser)
                                .padding()
                        }
                    }
                }
                .offset(y: -17)
            }
        }
        .ignoresSafeArea()
        .task {
            await authManager.fetchUser()
            isLoading = false
        }
    }

    private func fetchPosts(completion: @escaping ([Post]) -> Void) {
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error)")
                completion([])
                return
            }

            guard let documents = snapshot?.documents else {
                print("No documents found")
                completion([])
                return
            }

            let posts: [Post] = documents.compactMap { document in
                let data = document.data()
                guard let postManagerID = data["postManagerID"] as? String,
                      let title = data["title"] as? String,
                      let postContent = data["postContent"] as? String,
                      let location = data["location"] as? String,
                      let eventDate = data["eventDate"] as? String,
                      let tagsData = data["tags"] as? [[String: Any]] else {
                    return nil
                }

                let tags: [Tag] = tagsData.compactMap { tagData in
                    guard let name = tagData["name"] as? String,
                          let type = tagData["type"] as? String else { return nil }
                    return Tag(name: name, type: type)
                }

                let postImage = UIImage(systemName: "photo")!

                return Post(
                    postManager: postManagerID,
                    title: title,
                    postImage: postImage,
                    postContent: postContent,
                    location: location,
                    eventDate: eventDate,
                    likes: data["likes"] as? Int ?? 0,
                    comments: [],
                    tags: tags
                )
            }

            completion(posts)
        }
    }
}
