//
//  User.swift
//  InstagramClone
//
//  Created by 영현 on 2/5/24.
//

import Foundation

struct User: Hashable, Identifiable, Codable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var fullname: String?
    var bio: String?
    let email: String
}

extension User {
    static var MOCK_USERS: [User] = [
        .init(id: NSUUID().uuidString, username: "naruto", profileImageUrl: "naruto-profile", fullname: "Uzumaki Naruto", bio: "🦊🍜🍥", email: "naruto@gmail.com"),
        .init(id: NSUUID().uuidString, username: "sakura", profileImageUrl: "sakura-profile", fullname: "Haruno Sakura", bio: "𑁍 ⋆ ⋆｡°✩", email: "sakura@gmail.com"),
        .init(id: NSUUID().uuidString, username: "sasuke", profileImageUrl: "sasuke-profile", fullname: "Uchiha Sasuke", email: "sasuke@gmail.com"),
        .init(id: NSUUID().uuidString, username: "kakashi", profileImageUrl: "kakashi-profile", fullname: "Hatake Kakashi", bio: "📖", email: "kakashi@gmail.com"),
        .init(id: NSUUID().uuidString, username: "sai", profileImageUrl: "sai-profile", bio: "🎨", email: "sai@gmail.com")
    ]
}
