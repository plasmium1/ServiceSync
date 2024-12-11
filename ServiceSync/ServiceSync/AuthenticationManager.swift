//
//  AuthenticationManager.swift
//  ServiceSync
//
//  Created by AW on 12/9/24.
//

import Foundation

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthenticationManager: ObservableObject {
    @Published var user: User? // Your custom User object
    @Published var isLoading = true

    private let db = Firestore.firestore()

    init() {
        // Listen for auth state changes
        Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            guard let firebaseUser = firebaseUser else {
                self?.user = nil
                self?.isLoading = false
                return
            }
            self?.loadUserData(for: firebaseUser.uid)
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self?.loadUserData(for: Auth.auth().currentUser!.uid)
                completion(.success(()))
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    private func loadUserData(for uid: String) {
        isLoading = true

        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                self?.isLoading = false
                return
            }

            let email = data["email"] as? String ?? ""
            let username = data["username"] as? String ?? ""
            let role = data["role"] as? String ?? ""
            let id = data["id"] as? String ?? ""

            if role == "Student" {
                // Create a StudentUser
                let age = data["age"] as? Int ?? 0
                let name = data["name"] as? String ?? ""
                let aboutMe = data["aboutMe"] as? String ?? ""
                let badges = data["badges"] as? [String] ?? []
                let interests = data["interests"] as? [String] ?? []
                let student = StudentUser(name: name, username: username, id: id, age: age, interests: interests.map { UUID(uuidString: $0)! }, aboutMe: aboutMe, email: email, profileImage: nil, badges: badges)
                self?.user = student
            } else if role == "Manager" {
                // Create a ManagerUser
                let telephone = data["telephone"] as? Int ?? 0
                let description = data["description"] as? String ?? ""
                let website = data["website"] as? String
                let badges = data["badges"] as? [String] ?? []
                let manager = ManagerUser(programName: username, id: id, email: email, telephone: telephone, description: description, profileImage: nil, website: website, badges: badges)
                self?.user = manager
            }

            self?.isLoading = false
        }
    }
    
    func signUpStudent(name: String, username: String, age: Int, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                return
            }

            guard let uid = authResult?.user.uid else { return }
            
            let studentData: [String: Any] = [
                "role": "Student",
                "name": name,
                "username": username,
                "age": age,
                "email": email,
                "aboutMe": "",
                "interests": [],
                "badges": []
            ]

            self?.db.collection("users").document(uid).setData(studentData) { error in
                if let error = error {
                    print("Error saving student data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func signUpManager(name: String, telephone: Int, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Error creating user: \(error.localizedDescription)")
                return
            }

            guard let uid = authResult?.user.uid else { return }

            let managerData: [String: Any] = [
                "role": "Manager",
                "name": name,
                "website": "",
                "telephone": telephone,
                "email": email,
                "description": "",
                "badges": []
            ]

            self?.db.collection("users").document(uid).setData(managerData) { error in
                if let error = error {
                    print("Error saving manager data: \(error.localizedDescription)")
                }
            }
        }
    }
}



