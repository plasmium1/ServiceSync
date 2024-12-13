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

@MainActor
class AuthenticationManager: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
            print("Logged in as \(email)")
        } catch {
            print("Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createStudentUser(withEmail email: String, password: String, name: String, age: Int, telephone: Int) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(username: name, role: "student", id: result.user.uid, profileImage: nil, email: email, badges: [], interests: [], description: "", age: age, telephone: telephone, website: "")
            let encodedUser = user.toDictionary()
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
                    
        } catch {
            print("Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func createManagerUser(withEmail email: String, password: String, name: String, age: Int, telephone: Int) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(username: name, role: "manager", id: result.user.uid, profileImage: nil, email: email, badges: [], interests: [], description: "", age: age, telephone: telephone, website: "")
            let encodedUser = user.toDictionary()
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
                    
        } catch {
            print("Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print ("Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        guard let user = Auth.auth().currentUser else {
            print("No user logged in to delete.")
            return
        }

        // Delete user data from Firestore
        do {
            let userId = user.uid
            try await Firestore.firestore().collection("users").document(userId).delete()
            print("User data deleted from Firestore.")
        } catch {
            print("Failed to delete user data from Firestore: \(error.localizedDescription)")
            return
        }

        // Delete Firebase Auth user
        do {
            try await user.delete()
            self.userSession = nil
            self.currentUser = nil
            print("Firebase Auth user deleted.")
        } catch let error as NSError {
            if error.code == AuthErrorCode.requiresRecentLogin.rawValue {
                print("Error: User needs to re-authenticate before account deletion.")
            } else {
                print("Failed to delete user: \(error.localizedDescription)")
            }
        }
    }

    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
    
}




