//
//  AuthService.swift
//  InstagramClone
//
//  Created by 영현 on 2/5/24.
//

import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()

    @Published var userSession: FirebaseAuth.User?
        
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("DEBUG: Failed to log in user with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createuser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("DEBUG: Failed to register user with error \(error.localizedDescription)")
        }
        
//        Auth.auth().createUser(withEmail: email, password: password) { result, error in
//            
//        }

    }
    
    func loadUserData() async throws {
        
    }
    
    func signout() {
        try? Auth.auth().signOut()
        self.userSession = nil
    }
}
