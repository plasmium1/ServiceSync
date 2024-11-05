//
//  ManagerView.swift
//  ServiceSync
//
//  Created by AW on 10/28/24.
//

import SwiftUI



struct ManagerView: View {
    @State var managerObject: ManagerUser
    @State var isEditing: Bool = false;
    @State var emailInputText: String = "";
    @State var descriptionInputText: String = "";
    var body: some View {
        @State var emailDefaultText: String = managerObject.getEmail()
        @State var descriptionDefaultText: String = managerObject.getDescription()
        VStack {
            TopBar()
            
            ZStack {
                Rectangle()
                    .frame(width: 160.0, height: 160.0)
                    .foregroundStyle(Color("profileBackgroundColor"))
                    .cornerRadius(10)
                if (isEditing) {
                    ImagePickerBox(profileUser: ImageUser(managerObject))
                } else {
                    managerObject.getProfileImage()
                        .resizable()
                        .frame(width:150, height:150)
                        .cornerRadius(10)
                }
            }
            Text(managerObject.getProgramName())
                .font(.title)
                .fontWeight(.bold)
            if (isEditing) {
                
                TextField("", text: $emailInputText)
                    .frame(width:250)
                    .background(Color("profileBackgroundColor"))
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .fontWeight(.thin)
                    .cornerRadius(8)
                
                HStack {
                    Text("About Your Program")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth:.infinity, alignment:.leading)
                    Spacer()
                    Button(action: {
                        isEditing.toggle()
                        managerObject.setEmail(email: emailInputText)
                        managerObject.setDescription(description: descriptionInputText)
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                            .padding(.all, 10.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                ZStack {
                    Rectangle()
                        .frame(width: 360, height: 200)
                        .foregroundStyle(Color("profileBackgroundColor"))
                        .cornerRadius(10)
                    TextEditor(text: $descriptionInputText)
                        .font(.body)
                        .frame(width:340, height:200)
                        .background(Color("profileBackgroundColor"))
                        
                }
            } else {
                Text(managerObject.getEmail())
                    .font(.subheadline)
                    .fontWeight(.thin)
                
                HStack {
                    Text("About Your Program")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth:.infinity, alignment:.leading)
                    Spacer()
                    Button(action: {
                        isEditing.toggle()
                        emailInputText = emailDefaultText
                        descriptionInputText = descriptionDefaultText
                    }) {
                        Text(isEditing ? "Done" : "Edit")
                            .padding(.all, 10.0)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    
                }
                .padding()
                
                ZStack {
                    Rectangle()
                        .frame(width: 360, height: 200)
                        .foregroundStyle(Color("profileBackgroundColor"))
                        .cornerRadius(10)
                    Text(managerObject.getDescription())
                        .font(.body)
                        .frame(width:360, height:200)
                }
            }
            Spacer()
            HStack {
                Text("Roster")
                Spacer()
                Text("Badges")
            }
            
        
            Spacer()
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .ignoresSafeArea()
        
    }
}

#Preview {
    ManagerView(managerObject: placeholderManager)
}
