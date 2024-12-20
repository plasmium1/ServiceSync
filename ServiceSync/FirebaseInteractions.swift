//
//  FirebaseInteractions.swift
//  ServiceSync
//
//  Created by AW on 11/18/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

//func uploadStudentUser(_ studentUser: StudentUser) {
//    let db = Firestore.firestore()
//    let data = studentUser.toDictionary()
//    let userID = Auth.auth().currentUser!.uid
//    
//    db.collection("studentUsers").document(userID).setData(data) { error in
//        if let error = error {
//            print("Error uploading StudentUser: \(error.localizedDescription)")
//        } else {
//            print("StudentUser uploaded successfully!")
//        }
//    }
//}
//
//func uploadManagerUser(_ managerUser: ManagerUser) {
//    let db = Firestore.firestore()
//    let data = managerUser.toDictionary()
//    
//    db.collection("managerUsers").document(managerUser.id).setData(data) { error in
//        if let error = error {
//            print("Error uploading ManagerUser: \(error.localizedDescription)")
//        } else {
//            print("ManagerUser uploaded successfully!")
//        }
//    }
//}
//
//func uploadProfileImage(userID: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
//    // Reference to Firebase Storage
//    let storageRef = Storage.storage().reference()
//    let imageRef = storageRef.child("profileImages/\(userID).jpg")
//    
//    // Convert UIImage to JPEG Data
//    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
//        completion(.failure(NSError(domain: "Invalid image", code: -1, userInfo: nil)))
//        return
//    }
//    
//    // Metadata for the file
//    let metadata = StorageMetadata()
//    metadata.contentType = "image/jpeg"
//    
//    // Upload data to Firebase Storage
//    imageRef.putData(imageData, metadata: metadata) { metadata, error in
//        if let error = error {
//            // Handle upload error
//            completion(.failure(error))
//        } else {
//            // Fetch download URL
//            imageRef.downloadURL { url, error in
//                if let error = error {
//                    // Handle URL retrieval error
//                    completion(.failure(error))
//                } else if let url = url {
//                    // Return the URL as a string
//                    completion(.success(url.absoluteString))
//                }
//            }
//        }
//    }
//}
//
//func uploadStudentUserWithImage(_ studentUser: StudentUser) {
//    guard let uiImage = studentUser.getProfileImage() else { uploadStudentUser(studentUser); return } // Convert `Image` to `UIImage`
//
//    uploadProfileImage(userID: studentUser.id, image: uiImage) { result in
//        switch result {
//        case .success(let imageUrl):
//            var data = studentUser.toDictionary()
//            data["profileImageUrl"] = imageUrl
//
//            Firestore.firestore()
//                .collection("studentUsers")
//                .document(studentUser.id)
//                .setData(data) { error in
//                    if let error = error {
//                        print("Error uploading StudentUser with image: \(error.localizedDescription)")
//                    } else {
//                        print("StudentUser with image uploaded successfully!")
//                    }
//                }
//        case .failure(let error):
//            print("Error uploading profile image: \(error.localizedDescription)")
//        }
//    }
//}
//
//func uploadManagerUserWithImage(_ managerUser: ManagerUser) {
//    guard let uiImage = managerUser.getProfileImage() else { return } // Convert `Image` to `UIImage`
//
//    uploadProfileImage(userID: managerUser.id, image: uiImage) { result in
//        switch result {
//        case .success(let imageUrl):
//            var data = managerUser.toDictionary()
//            data["profileImageUrl"] = imageUrl
//
//            Firestore.firestore()
//                .collection("studentUsers")
//                .document(managerUser.id)
//                .setData(data) { error in
//                    if let error = error {
//                        print("Error uploading ManagerUser with image: \(error.localizedDescription)")
//                    } else {
//                        print("ManagerUser with image uploaded successfully!")
//                    }
//                }
//        case .failure(let error):
//            print("Error uploading profile image: \(error.localizedDescription)")
//        }
//    }
//}
//
//func saveBadge(badge: Badge) {
//    let db = Firestore.firestore()
//    var badgeData: [String: Any] = [
//        "name": badge.name,
//        "id": badge.id
//    ]
//    
//    switch badge.badgeImageType {
//    case .system(let name):
//        badgeData["badgeImageType"] = "system"
//        badgeData["badgeImageValue"] = name
//    case .uploaded(let url):
//        badgeData["badgeImageType"] = "uploaded"
//        badgeData["badgeImageValue"] = url
//    }
//    
//    db.collection("badges").document(badge.id).setData(badgeData) { error in
//        if let error = error {
//            print("Error saving badge: \(error)")
//        } else {
//            print("Badge successfully saved.")
//        }
//    }
//}
//
//func loadBadges(completion: @escaping ([Badge]) -> Void) {
//    let db = Firestore.firestore()
//    db.collection("badges").getDocuments { snapshot, error in
//        if let error = error {
//            print("Error retrieving badges: \(error)")
//            completion([])
//            return
//        }
//        
//        guard let documents = snapshot?.documents else {
//            completion([])
//            return
//        }
//        
//        let badges: [Badge] = documents.compactMap { doc in
//            let data = doc.data()
//            let name = data["name"] as? String ?? ""
//            let id = data["id"] as? String ?? ""
//            let badgeImageType: Badge.BadgeImageType
//            
//            if let imageType = data["badgeImageType"] as? String,
//               let imageValue = data["badgeImageValue"] as? String {
//                if imageType == "system" {
//                    badgeImageType = .system(name: imageValue)
//                } else if imageType == "uploaded" {
//                    badgeImageType = .uploaded(url: imageValue)
//                } else {
//                    return nil
//                }
//                return Badge(name: name, badgeImageType: badgeImageType, id: id)
//            }
//            return nil
//        }
//        completion(badges)
//        badgesArray = badges
//    }
//}
//
//func loadManagerUsers(completion: @escaping (Result<[String: ManagerUser], Error>) -> Void) {
//    let db = Firestore.firestore()
//    var managerDictionary: [String: ManagerUser] = [:]
//    
//    db.collection("managerUsers").getDocuments(completion: { snapshot, error in
//        if let error = error {
//            completion(.failure(error))
//            return
//        }
//        
//        guard let documents = snapshot?.documents else {
//            completion(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No documents found."])))
//            return
//        }
//        
//        let dispatchGroup = DispatchGroup() // To wait for image downloads
//        
//        for document in documents {
//            let data = document.data()
//            let id = document.documentID
//            
//            // Parse data into a `ManagerUser` object
//            let username = data["username"] as? String ?? "Unknown"
//            let description = data["description"] as? String ?? "Unknown"
//            let website = data["website"] as? String ?? nil
//            let telephone = data["telephone"] as? Int ?? 0
//            let email = data["email"] as? String ?? "unknown@example.com"
//            let badges = data["badges"] as? [String] ?? []
//            let profileImageUrl = data["profileImageUrl"] as? String
//            let managerUser = ManagerUser(programName: username, id: id, email: email, telephone: telephone, description: description, profileImage: nil, website: website, badges: badges)
//            
//            if let profileImageUrl = profileImageUrl, let url = URL(string: profileImageUrl) {
//                            dispatchGroup.enter() // Track the download task
//                            
//                            URLSession.shared.dataTask(with: url) { data, response, error in
//                                if let data = data, let image = UIImage(data: data) {
//                                    DispatchQueue.main.async {
//                                        managerDictionary[id]?.profileImage = image
//                                    }
//                                }
//                                dispatchGroup.leave() // Mark this task as completed
//                            }.resume()
//                        }
//            
//            
//            // Add to dictionary
//            managerDictionary[id] = managerUser
//        }
//        
//        // Return the dictionary
//        dispatchGroup.notify(queue: .main) {
//                    completion(.success(managerDictionary))
//                }
//    })
//}
//
////Posts
//
func uploadPost(post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
    let db = Firestore.firestore()
//    let storage = Storage.storage().reference()

    let postID = post.id.uuidString
    var postData: [String: Any] = [
        "postManagerID": post.postManagerID,
        "id": postID,
        "title": post.title,
        "postContent": post.postContent,
        "eventDate": post.eventDate,
        "location": post.location,
        "likes": post.likes ?? 0,
        "comments": post.comments?.map { $0.toDictionary() } ?? [],
        "tags": post.tags.map { $0.toDictionary() },
        "reports": post.reports ?? [],
        "postImageURL": post.postImageURL ?? ""
    ]

    db.collection("posts").document(postID).setData(postData) { error in
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(()))
        }
    }
//    if let postImage = post.postImage, let imageData = postImage.jpegData(compressionQuality: 0.8) {
//        let imageRef = storage.child("postImages/\(postID).jpg")
//        imageRef.putData(imageData, metadata: nil) { _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            imageRef.downloadURL { url, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//                postData["postImageURL"] = url?.absoluteString
//                db.collection("posts").document(postID).setData(postData) { error in
//                    if let error = error {
//                        completion(.failure(error))
//                    } else {
//                        completion(.success(()))
//                    }
//                }
//            }
//        }
//    } else {
//        // No image case
//        db.collection("posts").document(postID).setData(postData) { error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
}


extension Comment {
    func toDictionary() -> [String: Any] {
        return ["postUser": postUser, "content": content, "likes": likes]
    }
    
    static func fromDictionary(_ dictionary: [String: Any]) -> Comment? {
        guard let postUser = dictionary["postUser"] as? String,
              let content = dictionary["content"] as? String,
              let likes = dictionary["likes"] as? Int else { return nil }
        return Comment(postUser: postUser, content: content, likes: likes)
    }
}

extension Tag {
    func toDictionary() -> [String: Any] {
        return ["name": name, "type": type]
    }
    
    static func fromDictionary(_ dictionary: [String: Any]) -> Tag? {
        guard let name = dictionary["name"] as? String,
              let type = dictionary["type"] as? String else { return nil }
        return Tag(name: name, type: type)
    }
}
