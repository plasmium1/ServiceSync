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
                .frame(height:100)
            Text("ServiceSync")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .offset(x: -2, y:22)
                .foregroundColor(.white)
            Text("ServiceSync")
                .font(.system(size: 20))
                .fontWeight(.bold)
                .offset(y: 22)
        }
    }
}

#Preview {
    TopBar()
}
