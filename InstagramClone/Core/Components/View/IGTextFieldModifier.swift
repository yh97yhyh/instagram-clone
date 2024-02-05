//
//  IGTextFieldModifier.swift
//  InstagramClone
//
//  Created by 영현 on 2/5/24.
//

import SwiftUI
import Foundation

struct IGTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}
