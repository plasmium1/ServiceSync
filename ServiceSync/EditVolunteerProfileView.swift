//
//  EditVolunteerProfileView.swift
//  ServiceSync
//
//  Created by AW on 11/13/24.
//

import SwiftUI

struct EditVolunteerProfileView: View {
    @ObservedObject var user: StudentUser
    
    @State private var newUsername = ""
    @State private var newEmail = ""
    
    // Dismiss action from environment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Your Profile")) {
                    TextField("Username", text: $newUsername)
                    TextField("Email", text: $newEmail)
                }
                
                Button("Save Changes") {
                    // Save changes to user (for demo purposes we just update the UI)
                    if !newUsername.isEmpty {
                        user.username = newUsername
                    }
                    if !newEmail.isEmpty {
                        user.setEmail(email: newEmail)
                    }
                    
                    // Close the sheet after saving
                    dismiss()
                }
                .padding()
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(trailing: Button("Cancel") {
                // Dismiss the sheet
                dismiss()
            })
        }
    }
}

