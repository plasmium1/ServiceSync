//
//  HomeScreen.swift
//  ServiceSync
//
//  Created by ECC on 10/19/24.
//

import SwiftUI

struct HomeScreen: View {
    
    var postsList = placeholderPostArray
    
    var body: some View {
        VStack {
            TopBar()
            
            ScrollView{
                ForEach(postsList) { post in
                    HomePostView(post: post)
                }
            }
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeScreen()
}
