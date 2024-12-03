//
//  HomeScreen.swift
//  ServiceSync
//
//  Created by ECC on 10/19/24.
//

import SwiftUI

struct HomeScreen: View {
    
    @State private var postsList = placeholderPostArray
    
    var body: some View {
        VStack {
            TopBar()
            
            ScrollView{
                ForEach(postsList) { post in
                    PostView(post: post, contextUser: post.postManager)
                        .padding()
                }
                
            }
            .offset(y: -17)
            
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    HomeScreen()
}
