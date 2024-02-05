//
//  LoginViewModel.swift
//  InstagramClone
//
//  Created by 영현 on 2/5/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
       try await AuthService.shared.login(withEmail: email, password: password)
    }
}
