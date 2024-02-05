//
//  FeedViewModel.swift
//  InstagramClone
//
//  Created by 영현 on 2/6/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    
    init() {
        Task { try await fetchPosts() }
    }
    
    @MainActor
    func fetchPosts() async throws {
        let snapshot = try await Firestore.firestore().collection("posts").getDocuments()
        self.posts = try snapshot.documents.compactMap( { try $0.data(as: Post.self) })
        //        self.posts = try snapshot.documents.compactMap({ document in
        //            let post = try document.data(as: Post.self)
        //            return post
        //        })

        for i in 0..<posts.count {
            let post = posts[i]
            let ownerUid = post.ownerUid
            let postUser = try await UserService.fetchUser(withUid: ownerUid)
            posts[i].user = postUser
        }
    }
}
