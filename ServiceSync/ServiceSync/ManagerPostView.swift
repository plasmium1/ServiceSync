//
//  ManagerPostView.swift
//  ServiceSync
//
//  Created by AW on 11/6/24.
//

import SwiftUI

struct ManagerPostView: View {
    @State private var posts = placeholderPostArray
    @State private var showForm = false
    @State var contextUser: ManagerUser
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(posts) { post in // Use binding to allow updates
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

                    // Show Form Fields if showForm is true
                    if showForm {
                        AddPostForm(posts: $posts, contextUser: contextUser)
                            .transition(.slide) // Adds slide animation
                    }
                }
            }
            .navigationTitle("Posts")
        }
    }
}

//#Preview {
//    ManagerPostView(contextUser: placeholderManager)
//}
