//
//  PostView.swift
//  ServiceSync
//
//  Created by AW on 11/5/24.
//

import SwiftUI

struct PostView: View {
    @State var post: Post // Binding to allow updates
    @State var contextUser: ManagerUser
    @State private var navigateToForm = false
    @State var showReport = false
    @State private var report: String = ""
    
    init(post: Post, contextUser: ManagerUser) {
        self.post = post
        self.contextUser = contextUser
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let logo = post.getPostManager().getProfileImage() {
                    Image(uiImage: logo)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                } else {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text(post.getPostManager().getUsername().prefix(1)) // First letter of organization name as placeholder
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                        )
                }
                Text(post.getPostManager().getUsername())
                    .font(.headline)
            }
            
            
            HStack{
                ForEach(post.getTags()){ tags in
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor( tags.getTypeColor())
                        
                        Text(tags.getName())
                            .scaledToFit()
                            
                    }
                    .frame(width:150)
                }
            }
            
            
            post.getPostImage()
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 250)
                .cornerRadius(10)
            
            Text(post.getPostContent())
                .font(.body)
                .padding()
            
            HStack {
                Text("Location: \(post.getLocation())")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 2)
                
                Spacer()
            }
            .padding(.top, 10) // Add padding above location text
            
            HStack {
                Text("Event Date: \(post.getEventDate())")
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
                
                // NavigationLink for Sign-Up button
                NavigationLink(value: post) {
                    Text("Sign Up")
                        .padding(.horizontal)
                        .frame(height: 30)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                
                
                
                
                
                Button(action: {
                    withAnimation {
                        showReport.toggle()
                    }
                }){
                    Image(systemName: showReport ? "flag.fill" : "flag")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                        .foregroundColor(.red)
                }
                
                
//
            }
            if showReport{
                ZStack{
                    
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.topPink)
                    
                    VStack{
                        Text("Tell us what's wrong?")
                            .font(.title)
                        
                        TextField("Write your report here", text: $report)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                       
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.green)
                                .frame(width:150, height: 50)
                            
                            Button("Submit Report"){
                                post.reports?.append(report)
                                report = ""
                            }
                            .padding()
                            .foregroundColor(.black)
                        }
                        
                    }
                    .padding()
                }
                .padding()
            }
            
            
            Divider()
        }
        .padding()
        .navigationDestination(for: Post.self) { post in
            EventFormView(viewModel: EventFormViewModel())
        }
    }
}



//#Preview {
//    PostView(post: placeholderPost1, contextUser: placeholderManager)
//}
