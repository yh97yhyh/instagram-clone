//
//  UserService.swift
//  InstagramClone
//
//  Created by 영현 on 2/6/24.
//

import Foundation
import FirebaseFirestore

class UserService {
    
    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: User.self) // Decoding
    }
    
    @MainActor
    static func fetchAllUsers() async throws -> [User] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        return snapshot.documents.compactMap( { try? $0.data(as: User.self) } )
        
//        let documnets = snapshot.documents
//        for doc in documnets {
//            guard let user = try? doc.data(as: User.self) else { return users}
//            users.append(user)
//        }
//        return users
    }
}
