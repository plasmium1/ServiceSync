import SwiftUI

struct Post: Identifiable {
    var id = UUID()
    var username: String
    var profileImage: Image
    var photo: Image
    var description: String
    var location: String
    var isLiked: Bool // New property to track if the post is liked
}

let samplePosts = [
    Post(username: "User1",
         profileImage: Image(systemName: "person.circle"),
         photo: Image("samplePhoto1"),
         description: "This is the first post!",
         location: "Location 1",
         isLiked: false),
    Post(username: "User2",
         profileImage: Image(systemName: "person.circle"),
         photo: Image("samplePhoto2"),
         description: "Here's another cool photo!",
         location: "Location 2",
         isLiked: false)
]

struct PostView: View {
    @Binding var post: Post // Binding to allow updates
    @State private var isLiked: Bool

    init(post: Binding<Post>) {
        self._post = post
        self._isLiked = State(initialValue: post.wrappedValue.isLiked) // Initialize the like state
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                post.profileImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                Text(post.username)
                    .font(.headline)
            }
            .padding(.bottom, 5)

            post.photo
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .cornerRadius(10)

            Text(post.description)
                .font(.body)
                .padding(.top, 5)

            HStack {
                Text("Location: \(post.location)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 2)

                Spacer()
            }
            .padding(.top, 10) // Add padding above location text

            HStack {
                Button(action: {
                    withAnimation {
                        isLiked.toggle()
                        post.isLiked = isLiked // Update the post's liked state
                    }
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? .red : .gray)
                        .font(.title)
                }
                Spacer()
            }

            Divider()
        }
        .padding()
    }
}


struct ContentView: View {
    @State private var posts = samplePosts
    @State private var showForm = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ForEach($posts) { $post in // Use binding to allow updates
                        PostView(post: $post)
                    }
                    
                    // Add Post Button
                    Button(action: {
                        withAnimation {
                            showForm.toggle()
                        }
                    }) {
                        Image(systemName: showForm ? "minus" : "plus")
                            .font(.largeTitle)
                            .padding()
                            .frame(width: 70, height: 70)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                    .padding()

                    // Show Form Fields if showForm is true
                    if showForm {
                        AddPostForm(posts: $posts)
                            .transition(.slide) // Adds slide animation
                    }
                }
            }
            .padding()
            .navigationTitle("Posts")
        }
    }
}

struct AddPostForm: View {
    @Binding var posts: [Post]
    @State private var username: String = "New User" // Default username
    @State private var photoName: String = ""
    @State private var description: String = ""
    @State private var location: String = ""

    var body: some View {
        VStack {
            TextField("Photo Name", text: $photoName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Description", text: $description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Location", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Add Post") {
                let newPost = Post(
                    username: username,
                    profileImage: Image(systemName: "person.circle"),
                    photo: Image(photoName), // Assuming the photo exists in assets
                    description: description,
                    location: location,
                    isLiked: false // Default to not liked
                )
                posts.append(newPost)
                // Clear fields after adding
                photoName = ""
                description = ""
                location = ""
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .animation(.easeInOut, value: posts.count) // Add animation for posts
    }
}

// Preview Provider
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
