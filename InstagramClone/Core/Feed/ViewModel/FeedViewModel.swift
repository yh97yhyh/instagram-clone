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
        self.posts = try await PostService.fetchFeedPosts()
    }
}
