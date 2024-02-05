//
//  MainTabView.swift
//  InstagramClone
//
//  Created by 영현 on 2/5/24.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            FeedView()
                .tabItem { Image(systemName: "house") }
            
            SearchView()
                .tabItem { Image(systemName: "magnifyingglass") }
            
            Text("Upload Post")
                .tabItem { Image(systemName: "plus.square") }
            
            Text("Notification")
                .tabItem { Image(systemName: "heart") }
            
            CurrentUserProfileView(user: User.MOCK_USERS[0])
                .tabItem { Image(systemName: "person") }
        }
        .accentColor(.black)
    }
}

#Preview {
    MainTabView()
}
