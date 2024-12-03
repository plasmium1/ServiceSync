//
//  BadgeView.swift
//  ServiceSync
//
//  Created by AW on 11/13/24.
//

import SwiftUI

struct BadgeView: View {
    @State var badge: Badge
    
    var body: some View {
        VStack {
            if let img = badge.getBadgeImage() {
                Image(uiImage: img.withRenderingMode(.alwaysTemplate)) // Badge Icon (can be customized)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.yellow)
            } else {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.yellow)
            }
            
            Text(badge.getName())
                .font(.caption)
                .padding(.top, 5)
        }
        .frame(width: 80, height: 100)
        .padding(10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
