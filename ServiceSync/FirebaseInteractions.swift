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

extension StudentUser {
    func toDictionary() -> [String: Any] {
        return [
                    "id": self.id.uuidString,
                    "username": self.username,
                    "name": self.name,
                    "age": self.age,
                    "aboutMe": self.aboutMe,
                    "email": self.email,
//                    "interests": self.interests.map { $0.uuidString }, // Assuming `Tag` has a `name` property
                    "badges": self.badges.map { $0 }, // Assuming `Badge` has an `id` property
                    "liked": self.liked.map { $0.uuidString }
                ]
    }
}

extension ManagerUser {
    func toDictionary() -> [String: Any] {
        return [
                    "id": self.id.uuidString,
                    "username": self.username,
                    "telephone": self.telephone,
                    "description": self.description,
                    "email": self.email,
                    "registeredStudents": self.registeredStudents.map { $0.uuidString },
                    "badges": self.badges.map { $0 }, // Assuming `Badge` has an `id` property
                    "liked": self.liked.map { $0.uuidString }
                ]
    }
}

func uploadStudentUser(_ studentUser: StudentUser) {
    let db = Firestore.firestore()
    let data = studentUser.toDictionary()
    
    db.collection("studentUsers").document(studentUser.id.uuidString).setData(data) { error in
        if let error = error {
            print("Error uploading StudentUser: \(error.localizedDescription)")
        } else {
            print("StudentUser uploaded successfully!")
        }
    }
}

func uploadManagerUser(_ managerUser: ManagerUser) {
    let db = Firestore.firestore()
    let data = managerUser.toDictionary()
    
    db.collection("managerUsers").document(managerUser.id.uuidString).setData(data) { error in
        if let error = error {
            print("Error uploading ManagerUser: \(error.localizedDescription)")
        } else {
            print("ManagerUser uploaded successfully!")
        }
    }
}

func uploadProfileImage(userID: UUID, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
    // Reference to Firebase Storage
    let storageRef = Storage.storage().reference()
    let imageRef = storageRef.child("profileImages/\(userID.uuidString).jpg")
    
    // Convert UIImage to JPEG Data
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        completion(.failure(NSError(domain: "Invalid image", code: -1, userInfo: nil)))
        return
    }
    
    // Metadata for the file
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
    
    // Upload data to Firebase Storage
    imageRef.putData(imageData, metadata: metadata) { metadata, error in
        if let error = error {
            // Handle upload error
            completion(.failure(error))
        } else {
            // Fetch download URL
            imageRef.downloadURL { url, error in
                if let error = error {
                    // Handle URL retrieval error
                    completion(.failure(error))
                } else if let url = url {
                    // Return the URL as a string
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
}

func uploadStudentUserWithImage(_ studentUser: StudentUser) {
    guard let uiImage = studentUser.getProfileImage() else { return } // Convert `Image` to `UIImage`

    uploadProfileImage(userID: studentUser.id, image: uiImage) { result in
        switch result {
        case .success(let imageUrl):
            var data = studentUser.toDictionary()
            data["profileImageUrl"] = imageUrl

            Firestore.firestore()
                .collection("studentUsers")
                .document(studentUser.id.uuidString)
                .setData(data) { error in
                    if let error = error {
                        print("Error uploading StudentUser with image: \(error.localizedDescription)")
                    } else {
                        print("StudentUser with image uploaded successfully!")
                    }
                }
        case .failure(let error):
            print("Error uploading profile image: \(error.localizedDescription)")
        }
    }
}

func uploadManagerUserWithImage(_ managerUser: ManagerUser) {
    guard let uiImage = managerUser.getProfileImage() else { return } // Convert `Image` to `UIImage`

    uploadProfileImage(userID: managerUser.id, image: uiImage) { result in
        switch result {
        case .success(let imageUrl):
            var data = managerUser.toDictionary()
            data["profileImageUrl"] = imageUrl

            Firestore.firestore()
                .collection("studentUsers")
                .document(managerUser.id.uuidString)
                .setData(data) { error in
                    if let error = error {
                        print("Error uploading ManagerUser with image: \(error.localizedDescription)")
                    } else {
                        print("ManagerUser with image uploaded successfully!")
                    }
                }
        case .failure(let error):
            print("Error uploading profile image: \(error.localizedDescription)")
        }
    }
}

func loadStudentUser(userID: String, completion: @escaping (Result<StudentUser, Error>) -> Void) {
    let db = Firestore.firestore()
    
    db.collection("studentUsers").document(userID).getDocument { document, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let document = document, document.exists, let data = document.data() else {
            completion(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Document does not exist or data is invalid."])))
            return
        }
        
        // Parse fields
        let name = data["name"] as? String ?? "Unknown"
        let username = data["username"] as? String ?? "Unknown"
        let age = data["age"] as? Int ?? 0
        let interests = (data["interests"] as? [String])?.compactMap { UUID(uuidString: $0) } ?? []
        let aboutMe = data["aboutMe"] as? String ?? ""
        let email = data["email"] as? String ?? "unknown@example.com"
        let badges = data["badges"] as? [String] ?? []
        
        // Load profile image if URL exists
        var profileImage: UIImage? = nil
        if let profileImageUrl = data["profileImageUrl"] as? String, let url = URL(string: profileImageUrl) {
            // Load the image asynchronously
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    profileImage = UIImage(data: data)
                }
                
                // Initialize `StudentUser`
                let studentUser = StudentUser(
                    name: name,
                    username: username,
                    age: age,
                    interests: interests,
                    aboutMe: aboutMe,
                    email: email,
                    profileImage: profileImage,
                    badges: badges
                )
                
                DispatchQueue.main.async {
                    completion(.success(studentUser))
                }
            }.resume()
        } else {
            // No profile image URL
            let studentUser = StudentUser(
                name: name,
                username: username,
                age: age,
                interests: interests,
                aboutMe: aboutMe,
                email: email,
                profileImage: nil,
                badges: badges
            )
            completion(.success(studentUser))
        }
    }
}

func saveBadge(badge: Badge) {
    let db = Firestore.firestore()
    var badgeData: [String: Any] = [
        "name": badge.name,
        "id": badge.id
    ]
    
    switch badge.badgeImageType {
    case .system(let name):
        badgeData["badgeImageType"] = "system"
        badgeData["badgeImageValue"] = name
    case .uploaded(let url):
        badgeData["badgeImageType"] = "uploaded"
        badgeData["badgeImageValue"] = url
    }
    
    db.collection("badges").document(badge.id).setData(badgeData) { error in
        if let error = error {
            print("Error saving badge: \(error)")
        } else {
            print("Badge successfully saved.")
        }
    }
}

func loadBadges(completion: @escaping ([Badge]) -> Void) {
    let db = Firestore.firestore()
    db.collection("badges").getDocuments { snapshot, error in
        if let error = error {
            print("Error retrieving badges: \(error)")
            completion([])
            return
        }
        
        guard let documents = snapshot?.documents else {
            completion([])
            return
        }
        
        let badges: [Badge] = documents.compactMap { doc in
            let data = doc.data()
            let name = data["name"] as? String ?? ""
            let id = data["id"] as? String ?? ""
            let badgeImageType: Badge.BadgeImageType
            
            if let imageType = data["badgeImageType"] as? String,
               let imageValue = data["badgeImageValue"] as? String {
                if imageType == "system" {
                    badgeImageType = .system(name: imageValue)
                } else if imageType == "uploaded" {
                    badgeImageType = .uploaded(url: imageValue)
                } else {
                    return nil
                }
                return Badge(name: name, badgeImageType: badgeImageType, id: id)
            }
            return nil
        }
        completion(badges)
        badgesArray = badges
    }
}
