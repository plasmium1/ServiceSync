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
//        VStack{
            ZStack {
                Color("topPink")
                    .frame(height:100)
                    .offset(y:-80)
                Text("ServiceSync")
                    .offset(y: -50)
            }
            
            ScrollView{
                ForEach(postsList) { post in
                    
                    HomePostView(post: post)
                    
                }
                
                
                
            }
            .offset(y:-91)
        
        
            
            
            
            
//        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeScreen()
}
