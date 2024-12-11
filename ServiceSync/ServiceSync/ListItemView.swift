//
//  ListItemView.swift
//  MyListApp
//
//  Created by admin on 10/31/24.
//

import SwiftUI

struct ListItemView: View {
    var item: String

    var body: some View {
        HStack {
            Image(systemName: "star") // Add an icon
            Text(item)
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(item: "Sample Item")
    }
}

