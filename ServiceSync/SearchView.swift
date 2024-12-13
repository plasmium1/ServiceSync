import SwiftUI
import Firebase
import FirebaseStorage

struct SearchView: View {
    @EnvironmentObject var authManager: AuthenticationManager
    @State private var searchText = ""
    @State private var items: [Post] = []
    @State private var isDisclosed = false
    @State private var focusProgram = false
    @State private var focusContent = true
    @State private var offset = 0
    @State private var count = 0
    @State private var errorMessage: String?
    @State private var posts: [Post] = []
    
    @State private var stateOfFilters = filters
    
     var filteredItems: [Post] {
        if searchText.isEmpty {
            var tempItems = items
            (0...stateOfFilters.count-1) .forEach{ filter in
                if stateOfFilters[filter] == true{
                    (0...items.count-1) .forEach{ post in
                        var canStay = false
                        (0...items[post].getTags().count-1) .forEach{ tag in
                            
                            if items[post].getTags()[tag] == placeholderTagsArray[filter]{
                                canStay = true
                            }
                            
                            
                        }
                        
                        if canStay == false {
                            if tempItems.firstIndex(of: items[post]) != nil {
                                tempItems.remove(at: tempItems.firstIndex(of: items[post])!)
                            }
                        }
                    }
                }
            }
            return tempItems
        } else {
            var results: [Post] = []
            for post in posts {
                
                if focusContent == true{
                    if post.getPostContent().contains(searchText) || post.getPostContent().contains(searchText.lowercased()) {
                        results.append(post)
                        
                    }
                }
                else if focusProgram == true{
                    if post.getTitle().contains(searchText) || post.getTitle().contains(searchText.lowercased())  {
                        results.append(post)
                        
                    }
                }
                
                
                
            }
            
            if results.count > 1 {
                results.removeFirst()
            }
            var tempResults = results
            (0...stateOfFilters.count-1) .forEach{ filter in
                if stateOfFilters[filter] == true{
                    (0...results.count-1) .forEach{ post in
                        var canStay = false
                        (0...results[post].getTags().count-1) .forEach{ tag in
                            
                            if results[post].getTags()[tag] == placeholderTagsArray[filter]{
                                canStay = true
                            }
                            
                            
                        }
                        
                        if canStay == false {
                            if tempResults.firstIndex(of: results[post]) != nil {
                                tempResults.remove(at: tempResults.firstIndex(of: results[post])!)
                            }
                        }
                    }
                }
            }
            
            
            return tempResults
            
            
            
        }
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
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width:170, height: 50)
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
                        VStack {
                            VStack{
                                VStack(){
                                    Text("Search By:")
                                        .font(.headline)
                                    
                                    
                                    ZStack {
                                        
                                        Rectangle()
                                            .fill(.green)
                                            .border(.black)
                                            .frame(width: 200, height: 50)
                                            
                                            
                                        
                                        HStack {
                                            Button("Search Programs"){
                                                
                                                if focusContent == true{
                                                    focusContent.toggle()
                                                    focusProgram.toggle()
                                                }
                                                
                                                
                                                
                                            }
                                            .buttonStyle(.plain)
                                            
                                            if focusProgram == true{
                                                Image(systemName: "checkmark.square.fill")
                                            }
                                            else{
                                                Image(systemName: "checkmark.square")
                                            }
                                            
                                        }
                                    }
                                    
                                    ZStack {
                                        
                                        Rectangle()
                                            .fill(.green)
                                            .border(.black)
                                            .frame(width: 200, height: 50)
                                        
                                        HStack {
                                            Button("Search Content"){
                                                
                                                
                                                if focusProgram == true{
                                                    focusContent.toggle()
                                                    focusProgram.toggle()
                                                }
                                            }
                                            .buttonStyle(.plain)
                                            
                                            if focusContent == true{
                                                Image(systemName: "checkmark.square.fill")
                                            }
                                            else{
                                                Image(systemName: "checkmark.square")
                                            }
                                            
                                        }
                                    }
                                    .padding()
                                    
                                    
                                }
                                .padding()
                                
                                
                                
                                
                                
                                VStack() {
                                    Text("Filters:")
                                        .font(.headline)
                                    
                                    VStack {
                                        ForEach(placeholderTagsArray){ tag in
                                            
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(tag.getTypeColor())
                                                    .stroke(.black)
                                                    .frame(width: 200, height: 50)
                                                HStack {
                                                    
                                                    
                                                    Button(tag.getName()){
                                                            
                                                        stateOfFilters[placeholderTagsArray.firstIndex(of: tag)!].toggle()
                                                            
                                                        }
                                                        .frame(width: 150, height: 50)
                                                        .font(.system(size:20))
                                                        .buttonStyle(.plain)
                                                    
                                                    if stateOfFilters[placeholderTagsArray.firstIndex(of: tag)!] == true{
                                                        Image(systemName: "checkmark.square.fill")
                                                    }
                                                    else{
                                                        Image(systemName: "checkmark.square")
                                                    }
                                                    
                                                }
                                            }
//                                            .offset(y: CGFloat(integerLiteral: offset))
//
//                                            count = count + 1
                                            
                                            
                                            
                                        }
                                    }
                                    
                                }
                                    }
                            .padding()
                                }
                                .frame(width: isDisclosed ? nil: 0, height: isDisclosed ? nil : 0, alignment: .top)
                                .clipped()
                                
                               
                            }
//                            .frame(maxWidth: .infinity)
                            .background(.thinMaterial)
                            .padding()
                    
                    Divider()
                    // List of filtered results
                    ScrollView{
                        ForEach(filteredItems) { post in
                            PostView(post: post)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .onAppear {
                    setupPostListener() // setup the post listener
                }
            }
        }
        .ignoresSafeArea()
        
    }
    
    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("posts").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No posts found")
                return
            }
            
            let fetchedPosts = documents.compactMap { document -> Post? in
                let data = document.data()
                
                guard
                    let postManagerID = data["postManagerID"] as? String,
                    let title = data["title"] as? String,
                    let postContent = data["postContent"] as? String,
                    let location = data["location"] as? String,
                    let eventDate = data["eventDate"] as? String,
                    let tagsArray = data["tags"] as? [[String: Any]]
                else {
                    print("Error parsing post data for document ID: \(document.documentID)")
                    return nil
                }
                
                // Convert optional properties
                let likes = data["likes"] as? Int
                let commentsArray = data["comments"] as? [[String: Any]]
                let reportsArray = data["reports"] as? [String]
                
                // Load tags
                let tags = tagsArray.compactMap { Tag.fromDictionary($0) }
                
                // Load comments if any
                let comments = commentsArray?.compactMap { Comment.fromDictionary($0) }
                
                // Load post image (optional)
                var postImage = UIImage()
                if let imageURLString = data["postImageURL"] as? String,
                   let imageURL = URL(string: imageURLString),
                   let imageData = try? Data(contentsOf: imageURL) {
                    postImage = UIImage(data: imageData) ?? UIImage()
                }
                
                // Initialize the Post object
                return Post(
                    postManager: postManagerID,
                    title: title,
                    postImage: postImage,
                    postContent: postContent,
                    location: location,
                    eventDate: eventDate,
                    likes: likes ?? 0,
                    comments: comments ?? [],
                    tags: tags
                )
            }
            
            DispatchQueue.main.async {
                self.posts = fetchedPosts
            }
        }
    }


    func setupPostListener() {
        let db = Firestore.firestore()
        db.collection("posts").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error listening for posts: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("No posts found")
                return
            }
            
            do {
                let updatedPosts = try documents.compactMap { document -> Post? in
                    let post = try document.data(as: Post.self)
                    return post
                }
                DispatchQueue.main.async {
                    self.posts = updatedPosts
                }
            } catch {
                print("Error decoding posts: \(error.localizedDescription)")
            }
        }
    }

}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(AuthenticationManager())
    }
}

