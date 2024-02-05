//
//  RegisterationViewModel.swift
//  InstagramClone
//
//  Created by 영현 on 2/5/24.
//

import Foundation

class RegisterationViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    
    func createUser() async throws {
        try await AuthService.shared.createuser(email: email, password: password, username: username)
    }
    
}
