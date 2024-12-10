import SwiftUI
import Firebase
import FirebaseStorage

struct SearchView: View {
    @EnvironmentObject private var authManager: AuthenticationManager
    @State private var searchText = ""
    @State private var items = placeholderPostArray
    @State private var isDisclosed = false
    @State private var focusProgram = false
    @State private var focusContent = true
    @State private var currentUser: User? = nil
    @State private var stateOfFilters = filters
    
    var filteredItems: [Post] {
        var filtered = items
        
        // Apply text-based filtering
        if !searchText.isEmpty {
            filtered = filtered.filter { post in
                (focusContent && post.getPostContent().localizedCaseInsensitiveContains(searchText)) ||
                (focusProgram && post.getTitle().localizedCaseInsensitiveContains(searchText))
            }
        }
        
        // Apply tag-based filtering
        for (index, isEnabled) in stateOfFilters.enumerated() where isEnabled {
            let filterTag = placeholderTagsArray[index]
            filtered = filtered.filter { post in
                post.getTags().contains(filterTag)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        VStack {
            if filters.count == placeholderTagsArray.count {
                TopBar()
            }
            NavigationView {
                VStack {
                    // Search bar
                    TextField("Search...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 170, height: 50)
                                .foregroundColor(.green)
                            
                            Button("Search Options") {
                                withAnimation {
                                    isDisclosed.toggle()
                                }
                            }
                            .buttonStyle(.plain)
                            .font(.title3)
                            .padding()
                        }
                        .padding()
                        
                        if isDisclosed {
                            DisclosureView(
                                focusContent: $focusContent,
                                focusProgram: $focusProgram,
                                stateOfFilters: $stateOfFilters
                            )
                            .padding()
                        }
                    }
                    
                    Divider()
                    
                    // List of filtered results
                    ScrollView {
                        ForEach(filteredItems) { post in
                            PostView(post: post, contextUser: currentUser!)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .onAppear {
            loadCurrentUser { user in
                self.currentUser = user
            }
        }
        .ignoresSafeArea()
    }
    
    private func loadCurrentUser(completion: @escaping (User?) -> Void) {
        guard let user = authManager.user else {
            completion(nil)
            return
        }

        let userID = user.id
        let db = Firestore.firestore()

        db.collection("users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching user: \(error)")
                completion(nil)
                return
            }

            guard let data = document?.data(),
                  let role = data["role"] as? String,
                  let username = data["username"] as? String,
                  let email = data["email"] as? String else {
                completion(nil)
                return
            }

            let profileImage = UIImage(systemName: "person.circle")
            let badges = data["badges"] as? [String] ?? []

            if role == "student" {
                let name = data["name"] as? String ?? ""
                let age = data["age"] as? Int ?? 0
                let interests = data["interests"] as? [UUID] ?? []
                let aboutMe = data["aboutMe"] as? String ?? ""
                completion(StudentUser(
                    name: name,
                    username: username,
                    id: userID,
                    age: age,
                    interests: interests,
                    aboutMe: aboutMe,
                    email: email,
                    profileImage: profileImage,
                    badges: badges
                ))
            } else if role == "manager" {
                let telephone = data["telephone"] as? Int ?? 0
                let description = data["description"] as? String ?? ""
                let website = data["website"] as? String
                completion(ManagerUser(
                    programName: username,
                    id: userID,
                    email: email,
                    telephone: telephone,
                    description: description,
                    profileImage: profileImage,
                    website: website,
                    badges: badges
                ))
            } else {
                completion(nil)
            }
        }
    }
}

struct DisclosureView: View {
    @Binding var focusContent: Bool
    @Binding var focusProgram: Bool
    @Binding var stateOfFilters: [Bool]
    
    var body: some View {
        VStack {
            VStack {
                Text("Search By:")
                    .font(.headline)
                
                ToggleOption(
                    label: "Search Programs",
                    isSelected: $focusProgram,
                    onToggle: { focusContent = !focusProgram }
                )
                
                ToggleOption(
                    label: "Search Content",
                    isSelected: $focusContent,
                    onToggle: { focusProgram = !focusContent }
                )
            }
            
            Divider()
                .padding(.vertical)
            
            VStack {
                Text("Filters:")
                    .font(.headline)
                
                ForEach(placeholderTagsArray.indices, id: \.self) { index in
                    ToggleOption(
                        label: placeholderTagsArray[index].getName(),
                        isSelected: $stateOfFilters[index]
                    )
                }
            }
        }
    }
}

struct ToggleOption: View {
    let label: String
    @Binding var isSelected: Bool
    var onToggle: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(isSelected ? Color.green : Color.gray)
                .frame(width: 200, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.black, lineWidth: 1)
                )
            
            HStack {
                Button(label) {
                    withAnimation {
                        isSelected.toggle()
                        onToggle?()
                    }
                }
                .buttonStyle(.plain)
                .font(.system(size: 20))
                
                Image(systemName: isSelected ? "checkmark.square.fill" : "checkmark.square")
            }
        }
        .padding(.vertical, 4)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
