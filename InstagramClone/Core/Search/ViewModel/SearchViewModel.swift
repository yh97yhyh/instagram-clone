//
//  SearchViewModel.swift
//  InstagramClone
//
//  Created by 영현 on 2/6/24.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var users: [User] = []
    
    init() {
        Task { try await fetchAllUsers() }
    }
    
    @MainActor
    func fetchAllUsers() async throws {
        self.users = try await UserService.fetchAllUsers()
    }
}
