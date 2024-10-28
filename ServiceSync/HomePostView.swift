//
//  HomePostView.swift
//  ServiceSync
//
//  Created by ECC on 10/19/24.
//

import SwiftUI

struct HomePostView: View {
    
    @State var post: Post
    var body: some View {
        ZStack{
            Rectangle()
                .frame(height: 500)
                .foregroundColor(.white)
                
            VStack(alignment: .leading){
                HStack(){
                    Image("profilePic")
                        .resizable()
                        .clipShape(.circle)
                        .frame(width: 100, height: 100)
                    
                    Text(post.title)
                        .font(.title)
                    
                    
                }
                post.postImage
                    .resizable()
                    .frame(width:410, height:350)
                
                Text(post.postContent)
                    .padding()
                
                Divider()
            }
        }
    }
}

#Preview {
    HomePostView(post: placeholderPost1)
}
