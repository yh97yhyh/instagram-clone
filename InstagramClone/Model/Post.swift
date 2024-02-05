//
//  Post.swift
//  InstagramClone
//
//  Created by 영현 on 2/5/24.
//

import Foundation

struct Post: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String
    let caption: String
    var likes: Int
    let imageUrl: String
    let timestamp: Date
    var user: User?
}

extension Post {
    static var MOCK_POSTS: [Post] = [
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            caption: "hi this is test caption 1",
            likes: 812,
            imageUrl: "naruto-1",
            timestamp: Date(),
            user: User.MOCK_USERS[0]
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            caption: "hi this is test caption 2",
            likes: 862,
            imageUrl: "kakashi-1",
            timestamp: Date(),
            user: User.MOCK_USERS[3]
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            caption: "hi this is test caption 3",
            likes: 787,
            imageUrl: "sasuke-1",
            timestamp: Date(),
            user: User.MOCK_USERS[2]
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            caption: "hi this is test caption 4",
            likes: 679,
            imageUrl: "sakura-1",
            timestamp: Date(),
            user: User.MOCK_USERS[1]
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: NSUUID().uuidString,
            caption: "hi this is test caption 5 hi this is test caption 5",
            likes: 529,
            imageUrl: "sai-1",
            timestamp: Date(),
            user: User.MOCK_USERS[4]
        )
    ]
}
