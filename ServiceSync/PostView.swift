//
//  PostView.swift
//  ServiceSync
//
//  Created by AW on 11/5/24.
//

import SwiftUI

struct PostView: View {
    @Binding var post: Post // Binding to allow updates
    @ObservedObject var contextUser: User
    
    init(post: Binding<Post>, contextUser: User) {
        self._post = post
        self._contextUser = ObservedObject(initialValue: contextUser)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                post.getPostManager().getProfileImage()
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text(post.getPostManager().getProgramName())
                    .font(.headline)
            }
            .padding(.bottom, 5)

            post.getPostImage()
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .cornerRadius(10)

            Text(post.getPostContent())
                .font(.body)
                .padding(.top, 5)

            HStack {
                Text("Location: \(post.getLocation())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 2)

                Spacer()
            }
            .padding(.top, 10) // Add padding above location text

            HStack {
                Button(action: {
                    withAnimation {
                        if (contextUser.isPostLiked(post: post)) {
                            contextUser.unlikePost(id: post.getID())
                        } else {
                            contextUser.likePost(id: post.getID())
                        }
                    }
                }) {
                    Image(systemName: contextUser.isPostLiked(post: post) ? "heart.fill" : "heart")
                        .foregroundColor(contextUser.isPostLiked(post: post) ? .red : .gray)
                        .font(.title)
                }
                Spacer()
            }

            Divider()
        }
        .padding()
    }
}

//#Preview {
//    PostView(post: placeholderPost1, contextUser: placeholderManager)
//}
