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
    @State private var currentUser: User? = nil

    var body: some View {
        VStack {
            if isUserLoading {
                ProgressView("Loading User...")
            } else if currentUser == nil {
                Text("Failed to load user.")
                    .foregroundColor(.red)
            } else {
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
                            if let currentUser = currentUser {
                                PostView(post: post, contextUser: currentUser)
                                    .padding()
                            }
                        }
                    }
                    .offset(y: -17)
                }
            }
        }
        .onAppear {
            loadCurrentUser { user in
                self.currentUser = user
                self.isUserLoading = false
                if user != nil {
                    fetchPosts { posts in
                        self.postsList = posts
                        self.isLoading = false
                    }
                }
            }
        }
        .ignoresSafeArea()
    }

    private func loadCurrentUser(completion: @escaping (User?) -> Void) {
        guard let user = authManager.user else {
            completion(nil)
            return
        }

        let userID = user.id
        let db = Firestore.firestore()

        // Fetch the user document
        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching user: \(error)")
                completion(nil)
                return
            }

            guard let data = document?.data(),
                  let role = data["role"] as? String,
                  let username = data["username"] as? String,
                  let email = data["email"] as? String else {
                completion(nil)
                return
            }

            let profileImage = UIImage(systemName: "person.circle") // Default image or fetched from storage
            let badges = data["badges"] as? [String] ?? []

            if role == "student" {
                let name = data["name"] as? String ?? ""
                let age = data["age"] as? Int ?? 0
                let interests = data["interests"] as? [UUID] ?? []
                let aboutMe = data["aboutMe"] as? String ?? ""
                completion(StudentUser(
                    name: name,
                    username: username,
                    id: userID,
                    age: age,
                    interests: interests,
                    aboutMe: aboutMe,
                    email: email,
                    profileImage: profileImage,
                    badges: badges
                ))
            } else if role == "manager" {
                let telephone = data["telephone"] as? Int ?? 0
                let description = data["description"] as? String ?? ""
                let website = data["website"] as? String
                completion(ManagerUser(
                    programName: username,
                    id: userID,
                    email: email,
                    telephone: telephone,
                    description: description,
                    profileImage: profileImage,
                    website: website,
                    badges: badges
                ))
            } else {
                completion(nil)
            }
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
