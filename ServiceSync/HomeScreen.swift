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
    @State private var posts: [Post] = []
    @State private var isLoading = true
    @State private var isUserLoading = true

    var body: some View {
        VStack {
            TopBar()

            if isLoading {
                ProgressView("Loading Posts...")
            } else if posts.isEmpty {
                Text("No posts available")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                ScrollView {
                    ForEach(posts) { post in
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
            setupPostListener()
        }
        
    }

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
