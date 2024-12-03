//
//  DataModel.swift
//  ServiceSync
//
//  Created by AW on 10/17/24.
//

import Foundation
import SwiftUI


class User: ObservableObject {
    @Published var username: String
    var id = UUID()
    @Published var profileImage: UIImage?
    @Published var liked: [UUID] = []
    @Published var email: String
    @Published var badges: [String?] = []
    
    init(username: String, profileImage: UIImage?, email: String, badges: [String?]) {
        self.username = username
        self.profileImage = profileImage
        self.email = email
        self.badges = badges
    }
    
    func getUsername() -> String {
        return self.username
    }
    
    func getID() -> UUID {
        return self.id
    }
    func getEmail() -> String {
        return self.email
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
        return self.profileImage!
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
}

class StudentUser: User {
    @Published var name: String
    var interests: [UUID]?
    var aboutMe: String = ""
    @Published var age: Int
    
    
    init(name: String, username: String, age: Int, interests: [UUID]?, aboutMe: String, email: String, profileImage: UIImage?, badges: [String]) {
        self.name = name
        self.age = age
        self.interests = interests
        self.aboutMe = aboutMe
        super.init(username: username, profileImage: profileImage, email: email, badges: badges)
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getAge() -> Int {
        return self.age
    }
    
    func getInterests() -> [UUID]? {
        return self.interests!
    }
}

class ManagerUser: User {
    @Published var telephone: Int
    @Published var description: String
    @Published var registeredStudents: [UUID] = []
    @Published var website: String?
    
    
    init(programName: String, email: String, telephone: Int, description: String, profileImage: UIImage?, website: String?, badges: [String?]) {
        
        self.telephone = telephone
        self.description = description
        super.init(username: programName, profileImage: profileImage, email: email, badges: badges)
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
    
    func addStudent(student: StudentUser) {
        self.registeredStudents.append(student.getID())
    }
    
    func removeStudent(student: StudentUser) {
        for i in 0...registeredStudents.count {
            if registeredStudents[i] == student.getID() {
                registeredStudents.remove(at: i)
            }
        }
    }
    
}

class Tag: Identifiable {
    var name: String
    var type: String
    var id = UUID()
    
    init(name: String, type: String) {
        self.name = name
        self.type = type
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getType() -> String {
        return self.type
    }
    
    func getID() -> UUID {
        return self.id
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

class Post: Identifiable, Hashable, Equatable, ObservableObject {
    @Published var postManager: ManagerUser
    @Published var id = UUID()
    @Published var title: String
    @Published var postImage: Image
    @Published var postContent: String
    @Published var eventDate: String
    @Published var location: String
    @Published var likes: Int?
    @Published var comments: [Comment]?
    @Published var tags: [Tag]
    @Published var reports: [String]?
    
    init(postManager: ManagerUser, title: String, postImage: Image, postContent: String, location: String, eventDate: String, likes: Int, comments: [Comment], tags: [Tag]) {
        self.postManager = postManager
        self.title = title
        self.postImage = postImage
        self.postContent = postContent
        self.location = location
        self.eventDate = eventDate
        self.likes = likes
        self.comments = comments
        self.tags = tags
    }
    
    func getPostManager() -> ManagerUser {
        return self.postManager
    }
    
    func getID() -> UUID {
        return id
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getPostImage() -> Image {
        return self.postImage
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
            return [placeholderComment]
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
    
    func setPostImage(image: Image) {
        self.postImage = image
    }
    
    func setPostContent(content: String) {
        self.postContent = content
    }
}

class Comment {
    var postUser: StudentUser
    var content: String
    var likes: Int
    
    init(postUser: StudentUser, content: String, likes: Int) {
        self.postUser = postUser
        self.content = content
        self.likes = likes
    }
    
    func getUser() -> StudentUser {
        return self.postUser
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

var placeholderTag = Tag(name: "Making placeholders", type: "Civic Engagement")

var placeholderStudent = StudentUser(name: "Alex Konwar", username: "AKonwar", age: 17, interests: [placeholderTag.getID()], aboutMe: "I just love making placeholders", email: "fakeemail@gmail.com", profileImage: UIImage(named:"profilePic"), badges: ["completed_challenge", "volunteered_5_times", "volunteered_10_times", "stand_out"])

var placeholderComment = Comment(postUser: placeholderStudent, content: "Cool!", likes: 0)

var placeholderManager = ManagerUser(programName: "WE Bracelets", email: "fakeemail@gmail.com", telephone: 7735504264, description: "Someone make a fake description to fill this space", profileImage: UIImage(named:"profilePic"), website: "examplewebsite.com", badges: ["first_product"])

var placeholderManager2 = ManagerUser(programName: "Feed The People", email: "fakeemail@gmail.com", telephone: 7735504264, description: "Someone make a fake description to fill this space", profileImage: UIImage(named:"profilePic"), website: nil, badges: ["first_product", "best_startup"])


var placeholderPost1 = Post(postManager: placeholderManager, title: "WE Bracelets", postImage: Image("PlaceholderImageForPost"), postContent: "Hi everyone! We had an awesome first meeting for WE Bracelets. Looking forward to meeting more people. Please stop by next week for our Thursday meeting!", location: "Location", eventDate: "10/05/2006", likes: 0, comments: [placeholderComment], tags: [placeholderTag])

var placeholderPost2 = Post(postManager: placeholderManager2, title: "Feed The People", postImage: Image("FeedThePeopleImage"), postContent: "Hi everyone! We had an awesome first meeting for Feed The People. Looking forward to meeting more people. Please stop by next week for our Thursday meeting!", location: "Location", eventDate: "10/05/2006", likes: 0, comments: [placeholderComment], tags: [placeholderTag])

var placeholderPost3 = Post(postManager: placeholderManager2, title: "Nothing Here!", postImage: Image("FeedThePeopleImage"), postContent: "No results found", location: "Location", eventDate: "10/05/2006", likes: 0, comments: [placeholderComment], tags: [placeholderTag])

var placeholderPostArray = [placeholderPost1, placeholderPost2, placeholderPost3]


var badgesArray: [Badge] = [
    Badge(name: "Completed Challenge", badgeImageType: .system(name: "star.fill"), id: "completed_challenge"),
    Badge(name: "Volunteer 5 Times", badgeImageType: .system(name: "star.fill"), id: "volunteered_5_times"),
    Badge(name: "Volunteer 10 Times", badgeImageType: .system(name: "star.fill"), id: "volunteered_10_times"),
    Badge(name: "Stand Out", badgeImageType: .system(name: "star.fill"), id: "stand_out"),
    Badge(name: "First Product Launch", badgeImageType: .system(name: "star.fill"), id: "first_product"),
    Badge(name: "Awarded Best Startup", badgeImageType: .system(name: "star.fill"), id: "best_startup")
]

var studentArray: [StudentUser] = [placeholderStudent]
