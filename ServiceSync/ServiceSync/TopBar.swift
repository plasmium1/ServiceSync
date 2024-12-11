//
//  TopBar.swift
//  ServiceSync
//
//  Created by AW on 10/28/24.
//

import SwiftUI

struct TopBar: View {
    var body: some View {
        ZStack {
            Color("topPink")
                .frame(height:90)
            Text("ServiceSync")
                .font(.title)
                .fontWeight(.bold)
                .offset(x: -2, y:25)
                .foregroundColor(.white)
            Text("ServiceSync")
                .font(.title)
                .fontWeight(.bold)
                .offset(y: 23)
        }
    }
}

#Preview {
    TopBar()
}
