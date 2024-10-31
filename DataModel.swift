//
//  DataModel.swift
//  ServiceSync
//
//  Created by AW on 10/17/24.
//

import Foundation
import SwiftUI



class StudentUser {
    var name: String
    var username: String
    var id: Int
    var interests: [Tag]
    var badges: [Badge] = []
    var profileImage: Image?
    var aboutMe: String = ""
    
    
    init(name: String, username: String, id: Int, interests: [Tag], aboutMe: String) {
        self.name = name
        self.username = username
        self.id = id
        self.interests = interests
        self.aboutMe = aboutMe
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getusername() -> String {
        return self.username
    }
    
    func getID() -> Int {
        return self.id
    }
    
    func getInterests() -> [Tag] {
        return self.interests
    }
    
    func getBadges() -> [Badge] {
        return self.badges
    }
    
    func getImage() -> Image {
        return self.profileImage!
    }
    
    
    func setImage(image: Image) {
        self.profileImage = image
    }
}

class ManagerUser {
    var programName: String
    var email: String
    var telephone: Int
    var description: String
    var profileImage: Image?
    
    init(programName: String, email: String, telephone: Int, description: String, profileImage: Image) {
        self.programName = programName
        self.email = email
        self.telephone = telephone
        self.description = description
        self.profileImage = profileImage
    }
    
    func getProgramName() -> String {
        return self.programName
    }
    
    func getEmail() -> String {
        return self.email
    }
    
    func getTelephone() -> Int {
        return self.telephone
    }
    
    func getDescription() -> String {
        return self.description
    }
    
    func getProfileImage() -> Image {
        return self.profileImage!
    }
    
    func setProfileImage(image: Image) {
        self.profileImage = image
    }
}

class Tag: Identifiable {
    var name: String
    var type: String
    
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

class Post: Identifiable {
    var postManager: ManagerUser
    var title: String
    var postImage: Image
    var postContent: String
    var likes: Int?
    var comments: [Comment]?
    var tags: [Tag]
    
    init(postManager: ManagerUser, title: String, postImage: Image, postContent: String, likes: Int, comments: [Comment], tags: [Tag]) {
        self.postManager = postManager
        self.title = title
        self.postImage = postImage
        self.postContent = postContent
        self.likes = likes
        self.comments = comments
        self.tags = tags
    }
    
    func getPostManager() -> ManagerUser {
        return self.postManager
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

class Badge {
    var name: String
    var badgeImage: Image
    
    init(name: String, badgeImage: Image) {
        self.name = name
        self.badgeImage = badgeImage
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getBadgeImage() -> Image {
        return self.badgeImage
    }
    
    func setName(name: String) {
        self.name = name
    }
    
    func setBadgeImage(badgeImage: Image) {
        self.badgeImage = badgeImage
    }
}

var placeholderTag = Tag(name: "Making placeholders", type: "Civic Engagement")

var placeholderStudent = StudentUser(name: "Alex Konwar", username: "AKonwar", id: 50220137, interests: [placeholderTag], aboutMe: "I just love making placeholders")

var placeholderComment = Comment(postUser: placeholderStudent, content: "Cool!", likes: 0)

var placeholderManager = ManagerUser(programName: "WE Bracelets", email: "fakeemail@gmail.com", telephone: 7735504264, description: "Someone make a fake description to fill this space", profileImage: Image("profilePic"))

var placeholderManager2 = ManagerUser(programName: "Feed The People", email: "fakeemail@gmail.com", telephone: 7735504264, description: "Someone make a fake description to fill this space", profileImage: Image("profilePic"))


var placeholderPost1 = Post(postManager: placeholderManager, title: "WE Bracelets", postImage: Image("PlaceholderImageForPost"), postContent: "Hi everyone! We had an awesome first meeting for WE Bracelets. Looking forward to meeting more people. Please stop by next week for our Thursday meeting!", likes: 0, comments: [placeholderComment], tags: [placeholderTag])

var placeholderPost2 = Post(postManager: placeholderManager2, title: "Feed The People", postImage: Image("FeedThePeopleImage"), postContent: "Hi everyone! We had an awesome first meeting for Feed The People. Looking forward to meeting more people. Please stop by next week for our Thursday meeting!", likes: 0, comments: [placeholderComment], tags: [placeholderTag])

var placeholderPostArray = [placeholderPost1, placeholderPost2]
