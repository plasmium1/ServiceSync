//
//  EditOrganizationProfileView.swift
//  ServiceSync
//
//  Created by AW on 11/14/24.
//

import SwiftUI

struct EditOrganizationProfileView: View {
    @ObservedObject var organization: User
    
    @State private var newName = ""
    @State private var newEmail = ""
    @State private var newWebsite = ""
    @State private var newDescription = ""
    
    // Dismiss action from environment
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Your Organization Profile")) {
                    TextField("Organization Name", text: $newName)
                    TextField("Description", text: $newDescription)
                    TextField("Email", text: $newEmail)
                    TextField("Website", text: $newWebsite)
                }
                
                Button("Save Changes") {
                    // Save changes to organization
                    if !newName.isEmpty {
                        organization.setProgramName(programName: newName)
                    }
                    if !newEmail.isEmpty {
                        organization.setEmail(email: newEmail)
                    }
                    if !newWebsite.isEmpty {
                        organization.setWebsite(website: newWebsite)
                    }
                    if !newDescription.isEmpty {
                        organization.setDescription(description: newDescription)
                    }
                    
//                    uploadManagerUserWithImage(organization)
                    // Close the sheet after saving
                    dismiss()
                }
                .padding()
            }
            .navigationTitle("Edit Organization Profile")
            .navigationBarItems(trailing: Button("Cancel") {
                // Dismiss the sheet
                dismiss()
            })
        }
    }
}

