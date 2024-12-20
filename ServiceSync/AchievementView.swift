//
//  AchievementView.swift
//  ServiceSync
//
//  Created by AW on 11/14/24.
//

import SwiftUI

struct AchievementView: View {
    var achievement: Badge
    
    var body: some View {
        VStack {
            if let img = achievement.getBadgeImage() {
                Image(uiImage: img.withRenderingMode(.alwaysTemplate)) // Achievement Icon (can be customized)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.yellow)
            } else {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.yellow)
            }
            Text(achievement.getName())
                .font(.caption)
                .padding(.top, 5)
        }
        .frame(width: 80, height: 100)
        .padding(10)
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
