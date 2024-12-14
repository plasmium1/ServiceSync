//
//  DataModel.swift
//  ServiceSync
//
//  Created by AW on 10/17/24.
//

import Foundation
import SwiftUI

import Firebase
import FirebaseStorage
import UIKit

class User: ObservableObject, Codable {
    @Published var username: String
    var role: String
    var id: String
    @Published var profileImage: UIImage?
    @Published var liked: [UUID] = []
    @Published var email: String
    @Published var badges: [String?] = []
    @Published var interests: [String?] = []
    @Published var description: String
    @Published var age: Int
    @Published var telephone: Int
    @Published var website: String

    enum CodingKeys: String, CodingKey {
        case username, role, id, profileImage, liked, email, badges, interests, description, age, telephone, website
    }

    init(username: String, role: String, id: String, profileImage: UIImage?, email: String, badges: [String?], interests: [String?], description: String, age: Int, telephone: Int, website: String) {
        self.username = username
        self.role = role
        self.id = id
        self.profileImage = profileImage
        self.email = email
        self.badges = badges
        self.interests = interests
        self.description = description
        self.age = age
        self.telephone = telephone
        self.website = website
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.username = try container.decode(String.self, forKey: .username)
        self.role = try container.decode(String.self, forKey: .role)
        self.id = try container.decode(String.self, forKey: .id)

        if let profileImageData = try container.decodeIfPresent(Data.self, forKey: .profileImage) {
            self.profileImage = UIImage(data: profileImageData)
        } else {
            self.profileImage = nil
        }

        self.liked = try container.decode([UUID].self, forKey: .liked)
        self.email = try container.decode(String.self, forKey: .email)
        self.badges = try container.decode([String?].self, forKey: .badges)
        self.interests = try container.decode([String?].self, forKey: .interests)
        self.description = try container.decode(String.self, forKey: .description)
        self.age = try container.decode(Int.self, forKey: .age)
        self.telephone = try container.decode(Int.self, forKey: .telephone)
        self.website = try container.decode(String.self, forKey: .website)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(role, forKey: .role)
        try container.encode(id, forKey: .id)

        if let profileImage = profileImage {
            let profileImageData = profileImage.jpegData(compressionQuality: 1.0)
            try container.encode(profileImageData, forKey: .profileImage)
        } else {
            try container.encodeNil(forKey: .profileImage)
        }

        try container.encode(liked, forKey: .liked)
        try container.encode(email, forKey: .email)
        try container.encode(badges, forKey: .badges)
        try container.encode(interests, forKey: .interests)
        try container.encode(description, forKey: .description)
        try container.encode(age, forKey: .age)
        try container.encode(telephone, forKey: .telephone)
        try container.encode(website, forKey: .website)
        
    }

    func getUsername() -> String {
        return self.username
    }
    
    func getID() -> String {
        return self.id
    }
    
    func setID(id: String) {
        self.id = id
    }
    
    func getEmail() -> String {
        return self.email
    }
    
    func getAge() -> Int {
        return self.age
    }

    func getInterests() -> [String?] {
        return self.interests
    }
    
    func likePost(id: UUID) {
        self.liked.append(id)
    }
    
    func isPostLiked(post: Post) -> Bool {
        return self.liked.contains(post.getID())
    }
    
    func unlikePost(id: UUID) {
        for post in 0...liked.count {
            if (liked[post] == id) {
                liked.remove(at: post)
                break
            }
        }
    }
    
    func getProfileImage() -> UIImage? {
        return self.profileImage
    }
    
    func setProfileImage(image: UIImage?) {
        self.profileImage = image
    }
    
    func setEmail(email: String) {
        self.email = email
    }
    
    func getBadges() -> [String?] {
        return self.badges
    }
    
    func earnBadge(badgeID: String) {
        for badge in 0...badges.count {
            if (badgesArray[badge].getID() == badgeID) {
                badges.append(badgesArray[badge].getID())
            }
        }
    }
    
    func getTelephone() -> Int {
        return self.telephone
    }

    func getDescription() -> String {
        return self.description
    }

    func getWebsite() -> String! {
        return self.website
    }

    func setProgramName(programName: String) {
        self.username = programName
    }

    func setDescription(description: String) {
        self.description = description
    }

    func setWebsite(website: String) {
        self.website = website
    }
    
    func toDictionary() -> [String: Any] {
            var dictionary: [String: Any] = [
                "username": username,
                "role": role,
                "id": id,
                "liked": liked.map { $0.uuidString },
                "email": email,
                "badges": badges,
                "interests": interests,
                "description": description,
                "age": age,
                "telephone": telephone,
                "website": website
            ]

            if let profileImage = profileImage, let imageData = profileImage.pngData() {
                dictionary["profileImage"] = imageData
            } else {
                dictionary["profileImage"] = nil
            }


            return dictionary
        }
}

class Tag: Identifiable, Hashable, Equatable, Codable {
    var name: String
    var type: String
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    static func ==(lhs: Tag, rhs: Tag) -> Bool {
            return lhs.name == rhs.name
        }
    
    func hash(into hasher: inout Hasher) {
       hasher.combine(name)
     }
    
    func getName() -> String {
        return self.name
    }
    
    func getType() -> String {
        return self.type
    }
    
    func getTypeColor() -> Color {
        switch type {
            case "Age Group":
                return Color.yellow
            case "Tech":
                return Color.blue
            case "Arts":
                return Color.pink
            case "Sports":
                return Color.red
            case "Culinary":
                return Color.green
            case "Civic Engagement":
                return Color.orange
            default:
                return Color.black
        }
    }
}

class Post: Identifiable, Hashable, Equatable, ObservableObject, Codable {
    @Published var postManagerID: String
    @Published var id: UUID
    @Published var title: String
    @Published var postImageURL: String? // Optional image
    @Published var postContent: String
    @Published var eventDate: String
    @Published var location: String
    @Published var likes: Int?
    @Published var comments: [Comment]?
    @Published var tags: [Tag]
    @Published var reports: [String]?

    init(postManager: String, title: String, postImageURL: String = "", postContent: String, location: String, eventDate: String, likes: Int = 0, comments: [Comment] = [], tags: [Tag] = []) {
        self.postManagerID = postManager
        self.id = UUID()
        self.title = title
        self.postImageURL = postImageURL
        self.postContent = postContent
        self.location = location
        self.eventDate = eventDate
        self.likes = likes
        self.comments = comments
        self.tags = tags
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        return lhs.id == rhs.id
    }

    // Custom Codable implementation
    enum CodingKeys: String, CodingKey {
        case postManagerID, id, title, postImageURL, postContent, eventDate, location, likes, comments, tags, reports
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postManagerID = try container.decode(String.self, forKey: .postManagerID)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.postImageURL = try container.decode(String.self, forKey: .postImageURL)
        self.postContent = try container.decode(String.self, forKey: .postContent)
        self.eventDate = try container.decode(String.self, forKey: .eventDate)
        self.location = try container.decode(String.self, forKey: .location)
        self.likes = try container.decodeIfPresent(Int.self, forKey: .likes)
        self.comments = try container.decodeIfPresent([Comment].self, forKey: .comments)
        self.tags = try container.decode([Tag].self, forKey: .tags)
        self.reports = try container.decodeIfPresent([String].self, forKey: .reports)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(postManagerID, forKey: .postManagerID)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(postImageURL, forKey: .postImageURL)
        try container.encode(postContent, forKey: .postContent)
        try container.encode(eventDate, forKey: .eventDate)
        try container.encode(location, forKey: .location)
        try container.encodeIfPresent(likes, forKey: .likes)
        try container.encodeIfPresent(comments, forKey: .comments)
        try container.encode(tags, forKey: .tags)
        try container.encodeIfPresent(reports, forKey: .reports)
    }
    
    func getPostManager() async -> User? {
        do {
            let snapshot = try await Firestore.firestore()
                .collection("users")
                .document(postManagerID)
                .getDocument()

            if let data = snapshot.data() {
                return try? Firestore.Decoder().decode(User.self, from: data)
            } else {
                print("No data found for the document ID: \(postManagerID)")
            }
        } catch {
            print("Failed to fetch post manager: \(error.localizedDescription)")
        }
        return nil
    }
    
    func getID() -> UUID {
        return id
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getPostImage() -> AsyncImage<Image>? {
        if let image = self.postImageURL {
            return AsyncImage(url: URL(string: image))
        } else {
            return nil
        }
    }
    
    func getPostContent() -> String {
        return self.postContent
    }
    
    func getLocation() -> String {
        return self.location
    }
    
    func getEventDate() -> String {
        return self.eventDate
    }
    
    
    func getLikes() -> Int {
        if let postLike = likes{
            return postLike
        }
        else{
            return 0
        }
    }
    
    func getComments() -> [Comment] {
        if let postComments = comments{
            return postComments
        }
        else{
            return []
        }
    }
    
    func getTags() -> [Tag] {
        return self.tags
    }
    
    func incrementLikes() {
        if var postLikes = likes{
            postLikes += 1
        }
    }
    
    func appendComment(newComment: Comment) {
        if var postComments = comments{
            postComments.append(newComment)
        }
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func setpostImageURL(image: String) {
        self.postImageURL = image
    }
    
    func setPostContent(content: String) {
        self.postContent = content
    }
    
    func setID(id: UUID) {
        self.id = id
    }
}

class Comment: Codable {
    var postUser: String
    var content: String
    var likes: Int
    
    init(postUser: String, content: String, likes: Int) {
        self.postUser = postUser
        self.content = content
        self.likes = likes
    }
    
    func getContent() -> String {
        return self.content
    }
    
    func getLikes() -> Int {
        return self.likes
    }
    
    func setContent(content: String) {
        self.content = content
    }
    
    func incrementLikes() {
        self.likes += 1
    }
}

class Badge: Identifiable {
    enum BadgeImageType {
        case system(name: String)
        case uploaded(url: String)
        
        var systemName: String? {
            if case let .system(name) = self {
                return name
            }
            return nil
        }
    }

    var name: String
    var badgeImageType: BadgeImageType
    var id: String

    init(name: String, badgeImageType: BadgeImageType, id: String) {
        self.name = name
        self.badgeImageType = badgeImageType
        self.id = id
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getBadgeImageType() -> BadgeImageType {
        return self.badgeImageType
    }
    
    
    func getID() -> String {
        return self.id
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func getBadgeImage() -> UIImage? {
        switch self.badgeImageType {
        case .system(let systemName):
            return UIImage(systemName: systemName)?.withTintColor(.yellow)
        case .uploaded(let url):
            if let url = URL(string: url), let data = try? Data(contentsOf: url) {
                return UIImage(data: data)
            }
            return nil
        }
    }
}

func badgeLookUp(id: String) -> Badge? {
    for badge in badgesArray {
        if badge.getID() == id {
            return badge
        }
    }
    return nil
}

var placeholderTag = Tag(name: "Civic Engagement", type: "Civic Engagement")

var placeholderTag2 = Tag(name: "Tech", type: "Tech")

var placeholderTag3 = Tag(name: "Arts", type: "Arts")

var placeholderTag4 = Tag(name: "Sports", type: "Sports")

var placeholderTagsArray = [placeholderTag, placeholderTag2,placeholderTag3, placeholderTag4]


//var placeholderStudent = StudentUser(name: "", username: "", id: "", age: 0, interests: [], aboutMe: "", email: "", profileImage: nil, badges: [])

//var placeholderComment = Comment(postUser: placeholderStudent, content: "Cool!", likes: 0)

//var placeholderManager = ManagerUser(programName: "WE Bracelets", email: "fakeemail@gmail.com", telephone: 7735504264, description: "Someone make a fake description to fill this space", profileImage: UIImage(named:"profilePic"), website: "examplewebsite.com", badges: ["first_product"])

//var placeholderManager2 = ManagerUser(programName: "Feed The People", email: "fakeemail@gmail.com", telephone: 7735504264, description: "Someone make a fake description to fill this space", profileImage: UIImage(named:"profilePic"), website: nil, badges: ["first_product", "best_startup"])


//var placeholderPost1 = Post(postManager: placeholderManager.getID(), title: "WE Bracelets", postImageURL: UIImage(named:"PlaceholderImageForPost")!, postContent: "Hi everyone! We had an awesome first meeting for WE Bracelets. Looking forward to meeting more people. Please stop by next week for our Thursday meeting!", location: "Location", eventDate: "10/05/2006", likes: 0, comments: [placeholderComment], tags: [placeholderTag])
//
//var placeholderPost2 = Post(postManager: placeholderManager2.getID(), title: "Feed The People", postImageURL: UIImage(named:"FeedThePeopleImage")!, postContent: "Hi everyone! We had an awesome first meeting for Feed The People. Looking forward to meeting more people. Please stop by next week for our Thursday meeting!", location: "Location", eventDate: "10/05/2006", likes: 0, comments: [placeholderComment], tags: [placeholderTag])
//
//var placeholderPost3 = Post(postManager: placeholderManager2.getID(), title: "Nothing Here!", postImageURL: UIImage(named:"FeedThePeopleImage")!, postContent: "No results found", location: "Location", eventDate: "10/05/2006", likes: 0, comments: [placeholderComment], tags: [placeholderTag])

var placeholderPostArray: [Post] = []


var badgesArray: [Badge] = [
    Badge(name: "Completed Challenge", badgeImageType: .system(name: "star.fill"), id: "completed_challenge"),
    Badge(name: "Volunteer 5 Times", badgeImageType: .system(name: "star.fill"), id: "volunteered_5_times"),
    Badge(name: "Volunteer 10 Times", badgeImageType: .system(name: "star.fill"), id: "volunteered_10_times"),
    Badge(name: "Stand Out", badgeImageType: .system(name: "star.fill"), id: "stand_out"),
    Badge(name: "First Product Launch", badgeImageType: .system(name: "star.fill"), id: "first_product"),
    Badge(name: "Awarded Best Startup", badgeImageType: .system(name: "star.fill"), id: "best_startup")
]

//var studentArray: [StudentUser] = [placeholderStudent]

var filters: [Bool] {
    var results = [false]
    
    (2...placeholderTagsArray.count) .forEach{ tag in
        results.append(false)
    }
    return results
}

//var managerDictionary: [String: ManagerUser] = [:]
//
//func fetchManagerUsers() {
//    loadManagerUsers { result in
//        switch result {
//        case .success(let loadedUsers):
//            managerDictionary = loadedUsers
//            print("Manager users loaded successfully.")
//        case .failure(let error):
//            print("Error loading manager users: \(error.localizedDescription)")
//        }
//    }
//}
